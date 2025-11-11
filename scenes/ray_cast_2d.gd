extends RayCast2D

@export var max_length: float = 2000.0
@export var max_bounces: int = 5

@onready var beam: Line2D = get_parent().get_node("Line2D")

func _ready() -> void:
	enabled = true
	target_position = Vector2.RIGHT * max_length

func _physics_process(_delta: float) -> void:
	beam.clear_points()
	beam.add_point(Vector2.ZERO)
	
	var current_position: Vector2 = global_position
	var current_direction: Vector2 = Vector2.RIGHT.rotated(get_parent().rotation)
	var remaining_length: float = max_length
	
	for i in range(max_bounces):
		global_position = current_position
		target_position = current_direction * remaining_length
		force_raycast_update()
		
		if is_colliding():
			var collision_point = get_collision_point()
			var collision_normal = get_collision_normal()
			
			beam.add_point(to_local(collision_point))
			
			current_direction = current_direction.bounce(collision_normal)
			
			var distance_traveled = current_position.distance_to(collision_point)
			remaining_length -= distance_traveled
			current_position = collision_point + collision_normal * 0.1  # Offset slightly to avoid self-collision
			
			if remaining_length <= 0:
				break
		else:
			beam.add_point(to_local(current_position + current_direction * remaining_length))
			break
	
	#resetting position
	global_position = get_parent().global_position
