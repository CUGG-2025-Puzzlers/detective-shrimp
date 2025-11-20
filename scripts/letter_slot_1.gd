extends Control



@onready var hover_bg = $MarginContainer/HoverRect

func _ready():
	hover_bg.visible = false


func _on_mouse_entered():
	hover_bg.visible = true

func _on_mouse_exited():
	hover_bg.visible = false


func _on_hover_rect_mouse_exited() -> void:
	hover_bg.visible = false


func _on_hover_rect_mouse_entered() -> void:
	pass # Replace with function body.
