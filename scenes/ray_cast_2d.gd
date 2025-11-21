extends RayCast2D

@export var max_length: float = 8000.0
@export var max_bounces: int = 10

@onready var beam: Line2D = get_parent().get_node("Line2D")

func _ready() -> void:
	enabled = true
	target_position = Vector2.RIGHT * max_length
	beam.clear_points()

# called when pressing button
func shoot() -> void:
	beam.clear_points()
	beam.add_point(Vector2.ZERO)

	var current_position: Vector2 = global_position
	var current_direction: Vector2 = Vector2.RIGHT   # first shot
	var remaining_length: float = max_length

	for i in range(max_bounces):
		# shots come from the current position
		global_position = current_position
		target_position = current_direction * remaining_length
		force_raycast_update()

		if is_colliding():
			var hit_point: Vector2 = get_collision_point()
			var hit_normal: Vector2 = get_collision_normal()
			var collider = get_collider()

			# shots come from the beam location
			beam.add_point(beam.to_local(hit_point))

			# if we hit reflector then we be bouncin
			if collider.is_in_group("reflector"):
				var traveled := current_position.distance_to(hit_point)
				remaining_length -= traveled
				if remaining_length <= 0.0:
					break

				current_direction = current_direction.bounce(hit_normal)

				#honestly dunno why I added this but it breaks the code if deleted
				current_position = hit_point + hit_normal * 0.1
				continue

			# anything not reflector stop
			break
		else:
			# no hit no stop
			beam.add_point(beam.to_local(current_position + current_direction * remaining_length))
			break

	# reset origin so next shot starts at light again
	global_position = get_parent().global_position
