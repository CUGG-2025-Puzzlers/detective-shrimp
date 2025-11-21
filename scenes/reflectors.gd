extends Area2D

var dragging: bool = false
@onready var sprite: Sprite2D = $reflector

func _ready() -> void:
	set_process_input(true)
	add_to_group("reflector")  # grouping reflectors

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var mouse_global: Vector2 = get_global_mouse_position()
			var mouse_local: Vector2 = to_local(mouse_global)

			if sprite.get_rect().has_point(mouse_local):
				dragging = true
		else:
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		global_position += event.relative
