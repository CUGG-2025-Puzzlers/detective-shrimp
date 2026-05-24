extends Node

signal requested_player_hide()
signal requested_player_show(pos: Vector2)

var game_settings: GameSettings = preload("res://resources/game_settings.tres")

var mouse_default = preload("res://textures/mouse_default.png")
var mouse_move = preload("res://textures/mouse_move.png")
var mouse_drag = preload("res://textures/mouse_drag.png")
var mouse_help = preload("res://textures/mouse_help.png")
var mouse_help_transparent = preload("res://textures/mouse_help_transparent.png")

var scale_factor

func _ready() -> void:
	_resize_cursors()

#region Cursor

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
	_resize_cursor(mouse_help_transparent, Input.CURSOR_FORBIDDEN)

func _resize_cursor(base_texture: Resource, cursor_shape):
	var image = base_texture.get_image()
	image.resize(int(base_texture.get_width() * scale_factor),
				int(base_texture.get_height() * scale_factor),
				Image.INTERPOLATE_NEAREST)
	var new_texture = ImageTexture.create_from_image(image)
	Input.set_custom_mouse_cursor(new_texture, cursor_shape)

# Resends a mouse click event at the specified position
func resend_mouse_click(pos: Vector2, pressed: bool) -> void:
	# Manually create an input event
	var press_event = InputEventMouseButton.new()
	press_event.button_index = MOUSE_BUTTON_LEFT
	press_event.pressed = pressed
	
	# Scale position by viewport scale for proper positioning
	press_event.position = pos * get_viewport().get_final_transform()[0][0]
	get_viewport().push_input(press_event)

#endregion

#region Game Flow

func start_game():
	transition_to_scene(Area.Car, false)

func end_cutscene(cutscene: Cutscene):
	match cutscene:
		Cutscene.Car:
			transition_to_scene(Area.Yard, true, Vector2(610, 265))
		Cutscene.End:
			transition_to_scene(Area.Credits, false)
			

func transition_to_scene(area: Area, show_player: bool = true, player_pos: Vector2 = Vector2.ZERO):
	var scene = get_scene_from_enum(area)
	
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().change_scene_to_packed(scene)
	GameEvents.change_scene(scene.resource_path)
	if show_player:
		show_player(player_pos)
	else:
		hide_player()

func get_scene_from_enum(area: Area) -> PackedScene:
	match area:
		Area.Car: return load("res://scenes/cutscenes/car.tscn")
		Area.Yard: return load("res://scenes/background art/yard.tscn")
		Area.Kitchen: return load("res://scenes/background art/kitchen.tscn")
		Area.LivingRoom: return load("res://scenes/background art/livingroom.tscn")
		Area.Hallway: return load("res://scenes/background art/hallway.tscn")
		Area.Bedroom: return load("res://scenes/background art/bedroom.tscn")
		Area.Basement: return load("res://scenes/cutscenes/end.tscn")
		Area.Credits: return load("res://scenes/end_credits.tscn")
	
	return null

func hide_player():
	requested_player_hide.emit()

func show_player(pos: Vector2):
	requested_player_show.emit(pos)

enum Cutscene {
	None,
	Car,
	End,
}

enum Area {
	Car,
	Yard,
	Kitchen,
	LivingRoom,
	Hallway,
	Bedroom,
	Basement,
	Credits,
}

#endregion

func get_direction_vector(dir: Direction) -> Vector2:
	match dir:
		Direction.Left:  return Vector2.LEFT
		Direction.Right: return Vector2.RIGHT
		Direction.Up:    return Vector2.UP
		Direction.Down:  return Vector2.DOWN
		_:               return Vector2.ZERO

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
