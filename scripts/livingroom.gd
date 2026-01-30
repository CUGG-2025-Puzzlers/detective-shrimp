extends Node2D

@export var background_music: AudioStream

func _ready() -> void:
	AudioManager.play_background_music(background_music)
	GameEvents.dialogue_ended.connect(_on_dialogue_ended)

func _on_dialogue_ended():
	await get_tree().create_timer(2.5).timeout
	return
