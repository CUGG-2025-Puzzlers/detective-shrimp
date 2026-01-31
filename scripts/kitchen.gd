extends Node2D

@export var background_music: AudioStream

func _ready() -> void:
	if background_music:
		AudioManager.play_background_music(background_music)
	Globals.show_player()
