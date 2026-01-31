extends Area2D

@export var victory_delay: float = 1.0  # Seconds before showing victory

var victory_triggered: bool = false

func _ready():
	add_to_group("target")

func on_light_hit():
	# Trigger victory after a delay
	if not victory_triggered:
		victory_triggered = true

		# Change the light beam color to green
		var light_source = get_tree().get_first_node_in_group("light_source")
		if light_source:
			var beam = light_source.get_node("Line2D")
			beam.default_color = Color(0, 1, 0)  # Green

		# Spawn confetti!
		spawn_confetti()

		await get_tree().create_timer(victory_delay).timeout
		trigger_victory()

func spawn_confetti():
	# Load shrimp texture
	var shrimp_texture = load("res://assets/ui/shrimp.png")

	# Create multiple confetti bursts across the screen
	var viewport_size = get_viewport_rect().size

	for i in range(5):  # 5 confetti emitters
		var confetti = CPUParticles2D.new()
		confetti.emitting = true
		confetti.one_shot = true
		confetti.explosiveness = 0.9
		confetti.amount = 30
		confetti.lifetime = 2.5

		# Use shrimp texture!
		confetti.texture = shrimp_texture

		# Position across the top of the screen
		confetti.global_position = Vector2(
			viewport_size.x * (0.1 + 0.2 * i),
			-20  # Start above the screen
		)

		# Emission shape - spread horizontally
		confetti.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
		confetti.emission_rect_extents = Vector2(40, 5)

		# Movement - fall down with spread
		confetti.direction = Vector2(0, 1)
		confetti.spread = 45.0
		confetti.initial_velocity_min = 80.0
		confetti.initial_velocity_max = 180.0
		confetti.gravity = Vector2(0, 150)

		# Size - smaller since we're using the shrimp image
		confetti.scale_amount_min = 0.05
		confetti.scale_amount_max = 0.12

		# Colors - tint the shrimps with fun colors
		confetti.color_ramp = create_confetti_gradient()

		# Rotation for tumbling effect
		confetti.angular_velocity_min = -180.0
		confetti.angular_velocity_max = 180.0

		# Add to scene
		get_tree().current_scene.add_child(confetti)

		# Auto-cleanup after particles finish
		var timer = get_tree().create_timer(4.0)
		timer.timeout.connect(func(): confetti.queue_free())

func create_confetti_gradient() -> Gradient:
	var gradient = Gradient.new()
	gradient.colors = [
		Color(1.0, 0.4, 0.5),    # Pink
		Color(1.0, 0.6, 0.2),    # Orange
		Color(0.9, 0.3, 0.4),    # Coral
		Color(1.0, 0.8, 0.3),    # Yellow
		Color(0.5, 0.9, 0.5),    # Light green
	]
	gradient.offsets = [0.0, 0.25, 0.5, 0.75, 1.0]
	return gradient

func trigger_victory():
	print("VICTORY! Puzzle solved!")
	GameEvents.reflection_complete = true
	await get_tree().create_timer(2).timeout
	Transition.transition()
	await Transition.on_transition_finished
	Globals.transition_to_scene(load("res://scenes/background art/kitchen.tscn"))
