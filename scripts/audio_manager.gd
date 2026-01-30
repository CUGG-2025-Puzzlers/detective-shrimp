extends Node

@export var default_fade_time: float = 2.5

@onready var music_player: AudioStreamPlayer = $%MusicPlayer

func _ready() -> void:
	music_player.finished.connect(_on_music_finished)

func play_background_music(music: AudioStream, fade_time: float = 2.5) -> void:
	music_player.stop()
	music_player.stream = music
	_fade_in_music(fade_time)

func _fade_in_music(fade_time):
	music_player.volume_linear = 0
	music_player.play()
	var tween = create_tween()
	tween.tween_property(music_player, "volume_linear", _get_volume(), fade_time).set_ease(Tween.EASE_IN)

func _on_music_finished():
	await get_tree().create_timer(1).timeout
	_fade_in_music(default_fade_time)

func _get_volume() -> float:
	return Globals.game_settings.music_volume / 300.0
