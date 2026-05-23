class_name LightBendingPuzzle
extends Puzzle

@onready var start_light_button = %StartLightButton

func _ready() -> void:
	start_light_button.pressed.connect(_on_start_pressed)

func start() -> void:
	var raycast = $LightSource/RayCast2D
	raycast.restart()
	for shrimp in get_tree().get_nodes_in_group("color_shrimp"):
		if shrimp.has_method("deactivate"):
			shrimp.deactivate()
	var letter = get_tree().get_first_node_in_group("target")
	if letter:
		letter.victory_triggered = false

func finish() -> void:
	print("Light puzzle complete!")
	GameEvents.reflection_complete = true

func _on_start_pressed() -> void:
	$LightSource/RayCast2D.shoot()
