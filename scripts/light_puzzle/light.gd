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
const HALF_GRID_CELL_SIZE: int = 16
const HALF_GRID_SIZE: Vector2 = Vector2(8, 8)

var beam_points: Array[Vector2]
var active_block_ids: Array[int]
var travel_direction: Globals.Direction
var bounces: int

func _ready() -> void:
	pass

func fire() -> void:
	_reset()
	_calculate_path()
	for point in beam_points:
		light_beam.add_point(point)

func _reset() -> void:
	print("Resetting light beam...")
	active_block_ids.clear()
	beam_points.clear()
	light_beam.clear_points()
	light_beam.default_color = default_color
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
	var collision_layer: int = PhysicsServer2D.body_get_collision_layer(tile_rid)
	
	# End the beam when reaching a wall or other unexpected collision
	if not collision_layer == OBJECT_LAYER:
		print("Hit wall! Ending beam")
		beam_points.append(hit_position)
		return true
	
	var tile_data: LightPuzzleTileData = LightPuzzleTileData.new()
	tile_data.get_tile_data(tile_map, tile_rid)
	
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
		return true
	
	# End beam if block is not active (block is solid)
	if tile_data.is_activable and not tile_data.activation_id in active_block_ids:
		print("Hit solid block! Ending beam")
		beam_points.append(hit_position)
		return true
	
	# Store activation ID for activable check
	if tile_data.is_activator:
		print("Hit activator! Adding ID %d to active IDs" % tile_data.activation_id)
		active_block_ids.append(tile_data.activation_id)
	
	# Pass through activators and active blocks (block is pass-through)
	beam_points.append(hit_position + Globals.get_direction_vector(travel_direction) * HALF_GRID_CELL_SIZE)
	return false

func _calculate_path() -> void:
	print("Calculating beam path...")
	var reached_end: bool = false
	
	bounces = 0
	travel_direction = fire_direction
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
