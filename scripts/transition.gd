extends CanvasLayer

signal on_transition_finished

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer

func ready():
	color_rect.visible = false
	
func _on_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		on_transition_finished.emit()
		animation_player.play("fade_to_scene")
	if anim_name == "fade_to_scene":
		color_rect.visible = false
		animation_player.animation_finished.disconnect()

func transition():
	animation_player.animation_finished.connect(_on_animation_finished)
	color_rect.visible = true
	animation_player.play("fade_to_black")
	
func fade_out():
	color_rect.visible = true
	animation_player.play("fade_to_black")
	
func fade_in():
	color_rect.visible = true
	animation_player.play("fade_to_scene")
