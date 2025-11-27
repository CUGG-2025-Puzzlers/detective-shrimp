class_name SlidePuzzleArrow
extends TextureRect

@export var direction: Globals.Direction
var scale_speed = Vector2(1, 1)
var scale_up
var frame_delta

func _process(delta: float) -> void:
	frame_delta = delta

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			on_mouse_down()

func on_mouse_down():
	SlidePuzzleEvents.select_direction(direction)

func on_mouse_entered():
	scale_up = true
	while scale_up && scale.x < 1:
		scale += scale_speed * frame_delta
		await Engine.get_main_loop().process_frame
	
	scale = Vector2(1, 1)

func on_mouse_exited():
	scale_up = false
	while not scale_up && scale.x > 0.8:
		scale -= scale_speed * frame_delta
		await Engine.get_main_loop().process_frame
	
	scale = Vector2(0.8, 0.8)
