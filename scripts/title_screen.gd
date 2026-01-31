extends Node2D

@export var background_music: AudioStream

func _ready() -> void:
	AudioManager.play_background_music(background_music)

func _on_start_pressed() -> void:
	Globals.start_game()

func _on_options_pressed() -> void:
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().quit()
