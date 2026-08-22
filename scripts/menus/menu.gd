class_name Menu
extends Node

@export var music: AudioManager.MusicTheme

func _ready() -> void:
	AudioManager.play_menu_music(music)
