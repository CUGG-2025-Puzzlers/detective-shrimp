extends Node

var mouse_move = load("res://textures/mouse_move.png")
var mouse_drag = load("res://textures/mouse_drag.png")

func _ready() -> void:
	Input.set_custom_mouse_cursor(mouse_move, Input.CURSOR_MOVE, Vector2(9, 13))
	Input.set_custom_mouse_cursor(mouse_drag, Input.CURSOR_DRAG, Vector2(9, 13))

enum SlidePuzzleValues {
	Empty,
	Wall,
	IndicatorKey,
	Indicator1x1,
	Indicator1x2,
	Indicator2x1,
	Indicator2x2,
	IndicatorTRL,
}

enum Direction {
	Left,
	Right,
	Up,
	Down,
}
