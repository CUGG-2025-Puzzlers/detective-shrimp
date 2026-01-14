extends Node

var mouse_move = load("res://textures/mouse_move.png")
var mouse_drag = load("res://textures/mouse_drag.png")

func _ready() -> void:
	Input.set_custom_mouse_cursor(mouse_move, Input.CURSOR_MOVE, Vector2(9, 13))
	Input.set_custom_mouse_cursor(mouse_drag, Input.CURSOR_DRAG, Vector2(9, 13))

# Resends a mouse click event at the specified position
func resend_mouse_click(pos: Vector2, pressed: bool) -> void:
	# Manually create an input event
	var press_event = InputEventMouseButton.new()
	press_event.button_index = MOUSE_BUTTON_LEFT
	press_event.pressed = pressed
	
	# Scale position by viewport scale for proper positioning
	press_event.position = pos * get_viewport().get_final_transform()[0][0]
	get_viewport().push_input(press_event)

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
