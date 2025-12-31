extends CharacterBody2D

const SPEED = 110.0

func _physics_process(delta: float) -> void:
	var horizontal = Input.get_axis("ui_left", "ui_right")
	var vertical = Input.get_axis("ui_up", "ui_down")
	var direction = Vector2(horizontal, vertical).normalized() * SPEED * delta

	move_and_collide(direction)
