class_name Light
extends Node2D

@export var max_raycast_distance: float = 500.0
@export var max_bounces: int = 20
@export var speed_of_light: float = 430.0
@export var fire_direction: Globals.Direction = Globals.Direction.Right
@export var default_color: Color
@export var completion_color: Color

@onready var light_beam: Line2D = %LightBeam
@onready var raycast: RayCast2D = %Raycast

const OBJECT_LAYER: int = 1 << (7 - 1) # Objects on collision layer 7
const HALF_GRID_SIZE: Vector2 = Vector2(8, 8)

var beam_points: Array[Vector2]
var active_activators: Array[ActivationData]
var travel_direction: Globals.Direction
var bounces: int
var hit_target = false

class ActivationData:
	var tile_pos: Vector2i
	var activation_id: int
	var length_from_start: float
	
	func _init(pos: Vector2i, id: int, length: float) -> void:
		tile_pos = pos
		activation_id = id
		length_from_start = length

func _ready() -> void:
	pass

func fire() -> void:
	_reset()
	_calculate_path()
	_animate_beam()

# Resets beam properties to their default values
func _reset() -> void:
	print("Resetting light beam...")
	bounces = 0
	beam_points.clear()
	active_activators.clear()
	travel_direction = fire_direction
	hit_target = false
	
	light_beam.clear_points()
	light_beam.material.set_shader_parameter("progress", 0.0)
	light_beam.material.set_shader_parameter("color", default_color)
	
	raycast.position = Vector2.ZERO
	raycast.target_position = raycast.position + Globals.get_direction_vector(fire_direction) * max_raycast_distance

# Handles collisions with reflectors
# Returns whether or not the beam should end
func _handle_reflector_collision(hit_position: Vector2, area: Area2D) -> bool:
	var reflector: Reflector = area.get_parent() as Reflector
	
	# Unexpected collision: ColliderShape2D but not a reflector
	if reflector == null:
		print("Unexpected Collision")
		push_warning("Unexpected Collision: Collided with %s instead of a reflector" % area.name)
		beam_points.append(hit_position)
		return true
	
	print("Handling reflector collision...")
	# Reflect the beam
	beam_points.append(hit_position)
	travel_direction = reflector.reflect(travel_direction)
	print("Beam deflected to face %s" % Globals.get_direction_name(travel_direction))
	
	bounces += 1
	return bounces >= max_bounces

# Handles the different tilemap object collisions
# Returns wheter or not the beam should end
func _handle_tilemap_object_collision(hit_position: Vector2, tile_map: TileMapLayer) -> bool:
	print("Handling tilemap object collision...")
	
	# Get the information about the tile that was collided with
	var tile_rid: RID = raycast.get_collider_rid()
	var tile_coords: Vector2i = tile_map.get_coords_for_body_rid(tile_rid)
	var collision_layer: int = PhysicsServer2D.body_get_collision_layer(tile_rid)
	
	# End the beam when reaching a wall or other unexpected collision
	if not collision_layer == OBJECT_LAYER:
		print("Hit wall! Ending beam")
		beam_points.append(hit_position)
		return true
	
	var tile_data: LightPuzzleTileData = LightPuzzleTileData.new(tile_map, tile_coords)
	
	# Unexpected collision: No tile found at collision position
	if not tile_data.valid:
		print("Unexpected Collision")
		push_warning("Unexpected Collision: No valid tile found at collision position (%d, %d)" % [hit_position.x, hit_position.y])
		beam_points.append(hit_position)
		return true
	
	# Unexpected collision: Not target, activator, or activable tile
	if not tile_data.is_target and not tile_data.is_activator and not tile_data.is_activable:
		print("Unexpected Collision")
		push_warning("Unexpected Collision: Collided with invalid tilemap object at (%d, %d)" % [hit_position.x, hit_position.y])
		beam_points.append(hit_position)
		return true
	
	# End beam if target reached
	if tile_data.is_target:
		print("Hit target! Ending beam")
		beam_points.append(hit_position)
		hit_target = true
		return true
	
	# End beam if block is not active (block is solid)
	if tile_data.is_activable and not _is_id_active(tile_data.activation_id):
		print("Hit solid block! Ending beam")
		beam_points.append(hit_position)
		return true
	
	# Pass through activators and store activation ID for activable check
	if tile_data.is_activator:
		print("Hit activator! Adding ID %d to active IDs" % tile_data.activation_id)
		beam_points.append(hit_position + Globals.get_direction_vector(travel_direction))
		var length: float = _get_beam_length()
		var activator_data: ActivationData = ActivationData.new(tile_coords, tile_data.activation_id, length)
		active_activators.append(activator_data)
		return false
	
	# Pass through active blocks (block is pass-through)
	beam_points.append(hit_position + Globals.get_direction_vector(travel_direction))
	return false

# Returns true if an active activator has the given ID
# Returns false otherwise
func _is_id_active(id: int) -> bool:
	for activator in active_activators:
		if activator.activation_id == id:
			return true
	
	return false

func _calculate_path() -> void:
	print("Calculating beam path...")
	var reached_end: bool = false
	
	beam_points.append(raycast.position)
	while not reached_end:
		print()
		
		# Get immediate raycast update
		raycast.position = beam_points.back() + Globals.get_direction_vector(travel_direction) * 2
		raycast.target_position = Globals.get_direction_vector(travel_direction) * max_raycast_distance
		raycast.force_raycast_update()
		
		# Go as far as the raycast if no collision is detected
		if not raycast.is_colliding():
			print("No collisions remaining. Total collision points: %d" % (len(beam_points) - 1))
			beam_points.append(raycast.target_position)
			break
		
		# Get collision info
		var collider = raycast.get_collider()
		var hit_position: Vector2 = (raycast.get_collision_point() - position).snapped(HALF_GRID_SIZE)
		print("Collided with %s at (%d, %d)" % [collider.name, hit_position.x, hit_position.y])
		
		# Bounce off reflectors
		if collider is Area2D:
			reached_end = _handle_reflector_collision(hit_position, collider as Area2D)
			continue
		
		# Interact with tile map object
		if collider is TileMapLayer:
			reached_end = _handle_tilemap_object_collision(hit_position, collider as TileMapLayer)
			continue
		
		# End beam when unexpected collision occurs
		print("Unexpected Collision")
		push_warning("Unexpected Collision: Collided with unhandled collider %s in object %s" % [collider.get_class(), collider.name])
		beam_points.append(hit_position)
		reached_end = true
	
	print("Finished calculating path with %d collision points" % (len(beam_points) - 1))

func _get_beam_length() -> float:
	if beam_points.size() < 2:
		return 0.0
	
	var length: float = 0.0
	for i in range(beam_points.size() - 1):
		length += beam_points[i].distance_to(beam_points[i + 1])
	
	return length

func _animate_beam() -> void:
	print("Animating beam...")
	for point in beam_points:
		light_beam.add_point(point)
	
	var tween: Tween
	var current_length: float = 0.0
	var total_length: float = _get_beam_length()
	var segment_length: float
	var animation_time: float
	
	# Animate in segments to each activator to allow for event firing
	for activator in active_activators:
		segment_length = activator.length_from_start - current_length
		current_length = activator.length_from_start
		animation_time = segment_length / speed_of_light
		
		var beam_percentage: float = current_length / total_length
		
		tween = create_tween()
		tween.tween_property(light_beam.material, "shader_parameter/progress", beam_percentage, animation_time).from_current()
		await tween.finished
		
		GameEvents.activate_activator(activator.tile_pos, activator.activation_id)
	
	# Animate remaining segment
	segment_length = total_length - current_length
	animation_time = segment_length / speed_of_light
	
	tween = create_tween()
	tween.tween_property(light_beam.material, "shader_parameter/progress", 1.0, animation_time).from_current()
	await tween.finished
	
	GameEvents.finish_beam()
	
	if hit_target:
		light_beam.material.set_shader_parameter("color", completion_color)
		GameEvents.hit_target()
		GameEvents.finish_puzzle(GameEvents.PuzzleTrigger.PuzzleLight)
