class_name Scene
extends Node

@export var background_music: AudioManager.MusicTheme

func _ready() -> void:
	AudioManager.play_background_music(background_music)
