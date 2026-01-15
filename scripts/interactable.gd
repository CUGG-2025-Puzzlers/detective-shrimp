extends TextureRect

@export var interaction_range: int
@export var dialogue: Dialogue
@export var event: Globals.EventTrigger

var interactable = false

func _ready() -> void:
	mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN

func _process(delta: float) -> void:
	if not interactable and is_player_in_range():
		interactable = true
		mouse_default_cursor_shape = Control.CURSOR_HELP
		return
	
	if interactable and not is_player_in_range():
		interactable = false
		mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN
		return

func _gui_input(event: InputEvent) -> void:
	# Checking for Mouse Button Left events
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			_on_mouse_down()
		elif event.is_released():
			_on_mouse_up()

func _on_mouse_down():
	pass

func _on_mouse_up():
	pass

func is_player_in_range() -> bool:
	return false
