extends Node

var mouse_move = load("res://textures/mouse_move.png")
var mouse_drag = load("res://textures/mouse_drag.png")

# Used in Cassette Puzzle
var on_color: Color = Color(0, 0.2, 1)
var off_color: Color = Color(1, 0, 0.2)
var null_color: Color = Color.WHITE

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
