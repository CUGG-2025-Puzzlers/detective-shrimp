extends Node

var game_settings: GameSettings = preload("res://resources/game_settings.tres")

var mouse_default = preload("res://textures/mouse_default.png")
var mouse_move = preload("res://textures/mouse_move.png")
var mouse_drag = preload("res://textures/mouse_drag.png")
var mouse_help = preload("res://textures/mouse_help.png")

var scale_factor

func _ready() -> void:
	_resize_cursors()

func _resize_cursors():
	var viewport_size = get_viewport().size
	var base_width = 1280.0
	var base_height = 720.0
	scale_factor = (min(viewport_size.x / base_width, viewport_size.y / base_height) *
					game_settings.mouse_scale)
	
	_resize_cursor(mouse_default, Input.CURSOR_ARROW)
	_resize_cursor(mouse_move, Input.CURSOR_MOVE)
	_resize_cursor(mouse_drag, Input.CURSOR_DRAG)
	_resize_cursor(mouse_help, Input.CURSOR_HELP)

func _resize_cursor(base_texture: Resource, cursor_shape):
	var image = base_texture.get_image()
	image.resize(int(base_texture.get_width() * scale_factor),
				int(base_texture.get_height() * scale_factor),
				Image.INTERPOLATE_NEAREST)
	var new_texture = ImageTexture.create_from_image(image)
	Input.set_custom_mouse_cursor(new_texture, cursor_shape)

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
