extends RayCast2D
@export var max_length: float = 800000.0
@export var max_bounces: int = 100
@export var animation_speed: float = 430.0  # pixels per second
@onready var beam: Line2D = get_parent().get_node("Line2D")

var is_shooting: bool = false
var beam_points: Array = []
var current_point_index: int = 0
var animation_progress: float = 0.0

func _ready() -> void:
	enabled = true
	target_position = Vector2.RIGHT * max_length
	beam.clear_points()

func _process(delta: float) -> void:
	if is_shooting:
		animate_beam(delta)

# Calculate all beam points
func shoot() -> void:
	beam.clear_points()
	beam_points.clear()
	current_point_index = 0
	animation_progress = 0.0
	
	beam_points.append(beam.to_local(global_position))
	
	var current_position: Vector2 = global_position
	var current_direction: Vector2 = Vector2.RIGHT
	var remaining_length: float = max_length
	
	for i in range(max_bounces):
		global_position = current_position
		target_position = current_direction * remaining_length
		force_raycast_update()
		
		if is_colliding():
			var hit_point: Vector2 = get_collision_point()
			var hit_normal: Vector2 = get_collision_normal()
			var collider = get_collider()
			
			beam_points.append(beam.to_local(hit_point))
			
			if collider.is_in_group("target"):
				if collider.has_method("on_light_hit"):
					collider.on_light_hit()
				break
			
			if collider is StaticBody2D or collider is TileMap:
				break
			
			if collider.is_in_group("reflector"):
				var traveled := current_position.distance_to(hit_point)
				remaining_length -= traveled
				if remaining_length <= 0.0:
					break
				current_direction = current_direction.bounce(hit_normal)
				current_position = hit_point + hit_normal * 0.1
				continue
			
			break
		else:
			beam_points.append(beam.to_local(current_position + current_direction * remaining_length))
			break
	
	global_position = get_parent().global_position
	is_shooting = true
	beam.clear_points()

func animate_beam(delta: float) -> void:
	if current_point_index >= beam_points.size():
		is_shooting = false
		return
	
	# Add first point if empty
	if beam.get_point_count() == 0:
		beam.add_point(beam_points[0])
		current_point_index = 1
		return
	
	if current_point_index < beam_points.size():
		var start_point = beam_points[current_point_index - 1]
		var end_point = beam_points[current_point_index]
		var distance = start_point.distance_to(end_point)
		
		animation_progress += animation_speed * delta
		
		if animation_progress >= distance:
			# Reached the point, move to next segment
			beam.add_point(end_point)
			current_point_index += 1
			animation_progress = 0.0
		else:
			# Interpolate along the segment
			var t = animation_progress / distance
			var current_pos = start_point.lerp(end_point, t)
			
			# Update last point
			if beam.get_point_count() > current_point_index:
				beam.set_point_position(beam.get_point_count() - 1, current_pos)
			else:
				beam.add_point(current_pos)

func stop_beam() -> void:
	is_shooting = false
	beam.clear_points()
	beam_points.clear()

func restart() -> void:
	stop_beam()
	# Reset reflector positions would go here
	# You'd need to store initial positions of reflectors
