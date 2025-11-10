extends Node2D

var is_dragging: bool = false

func _ready():
	set_process_input(true)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				is_dragging = true
			else:
				is_dragging = false

func _process(_delta):
	if is_dragging:
		var mouse_pos = get_global_mouse_position()
		var direction = mouse_pos - global_position
		rotation = direction.angle()
