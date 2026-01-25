extends RayCast2D
@export var max_length: float = 800000.0
@export var max_bounces: int = 100
@export var animation_speed: float = 430.0  # pixels per second
@onready var beam: Line2D = get_parent().get_node("Line2D")

var is_shooting: bool = false
var beam_points: Array = []
var current_point_index: int = 0
var animation_progress: float = 0.0
var hit_target: Node = null  # Store target to trigger when animation completes
var pending_shrimp_activations: Array = []  # Array of {point_index, shrimp}

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
	hit_target = null  # Reset target
	pending_shrimp_activations.clear()

	# Reset all shrimps before recalculating (so blocks reactivate if light moves away)
	for shrimp in get_tree().get_nodes_in_group("color_shrimp"):
		if shrimp.has_method("deactivate"):
			shrimp.deactivate()

	# Track which shrimps will be activated (for block passthrough logic)
	var activated_shrimps: Array = []

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
				# Store target - will trigger when animation reaches it
				hit_target = collider
				break

			# Shrimp blocks - check if their shrimp was activated this frame
			if collider.is_in_group("shrimp_block"):
				var block_is_open = false
				for shrimp in activated_shrimps:
					if shrimp.controlled_wall == collider:
						block_is_open = true
						break

				if block_is_open:
					# Pass through the now-transparent block
					var traveled := current_position.distance_to(hit_point)
					remaining_length -= traveled
					if remaining_length <= 0.0:
						break
					current_position = hit_point + current_direction * 1.0
					continue
				else:
					# Block is solid, stop here
					break

			# Shrimps get activated when light hits them, but light passes through
			if collider.is_in_group("color_shrimp"):
				# Store for animation - will activate when light visually reaches it
				var point_index = beam_points.size() - 1  # Current point index
				pending_shrimp_activations.append({"point_index": point_index, "shrimp": collider})
				activated_shrimps.append(collider)  # Track for block passthrough logic
				# Continue through the shrimp
				var traveled := current_position.distance_to(hit_point)
				remaining_length -= traveled
				if remaining_length <= 0.0:
					break
				current_position = hit_point + current_direction * 1.0
				continue

			if collider is StaticBody2D or collider is TileMap:
				break

			if collider.is_in_group("reflector"):
				var traveled := current_position.distance_to(hit_point)
				remaining_length -= traveled
				if remaining_length <= 0.0:
					break
				current_direction = current_direction.bounce(hit_normal)
				current_position = hit_point + current_direction * 2.0
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
		# Animation complete - trigger target if we hit one
		if hit_target and hit_target.has_method("on_light_hit"):
			hit_target.on_light_hit()
			hit_target = null
		return

	# Add first point if empty
	if beam.get_point_count() == 0:
		beam.add_point(beam_points[0])
		current_point_index = 1
		if current_point_index >= beam_points.size():
			is_shooting = false
			if hit_target and hit_target.has_method("on_light_hit"):
				hit_target.on_light_hit()
				hit_target = null
			return

	var start_point = beam_points[current_point_index - 1]
	var end_point = beam_points[current_point_index]
	var distance = start_point.distance_to(end_point)

	# Handle zero-distance segments
	if distance < 0.1:
		current_point_index += 1
		return

	animation_progress += animation_speed * delta

	# Calculate current position along segment
	var t = clamp(animation_progress / distance, 0.0, 1.0)
	var current_pos = start_point.lerp(end_point, t)

	# Update or add the animated tip point
	if beam.get_point_count() <= current_point_index:
		beam.add_point(current_pos)
	else:
		beam.set_point_position(current_point_index, current_pos)

	# Check if we reached the end of this segment
	if animation_progress >= distance:
		# Ensure the point is exactly at the target
		beam.set_point_position(current_point_index, end_point)

		# Check if any shrimps should be activated at this point
		for activation in pending_shrimp_activations:
			if activation["point_index"] == current_point_index:
				var shrimp = activation["shrimp"]
				if shrimp.has_method("on_light_hit"):
					shrimp.on_light_hit()

		current_point_index += 1
		animation_progress -= distance  # Carry over excess progress

func stop_beam() -> void:
	is_shooting = false
	beam.clear_points()
	beam_points.clear()

func restart() -> void:
	stop_beam()
	# Reset reflector positions would go here
	# You'd need to store initial positions of reflectors
