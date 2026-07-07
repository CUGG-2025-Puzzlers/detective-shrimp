class_name LightBendingPuzzle
extends Puzzle

func _ready() -> void:
	$LightSource/Button.pressed.connect(_on_start_pressed)

func get_type() -> GameData.PuzzleType:
	return GameData.PuzzleType.Light

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

func _on_start_pressed() -> void:
	$LightSource/RayCast2D.shoot()
