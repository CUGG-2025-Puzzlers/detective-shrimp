extends Node

@export var default_fade_time: float = 2.5

@onready var music_player: AudioStreamPlayer = $%MusicPlayer

var current_theme: MusicTheme
const THEMES: Dictionary[MusicTheme, AudioStream] = {
	MusicTheme.Main: preload("res://assets/sound&music/Shrimptective_theme.mp3"),
	MusicTheme.Puzzle: preload("res://assets/sound&music/Shrimp_Jazz.mp3"),
	MusicTheme.Car: preload("res://assets/sound&music/Shrimpin_Around.mp3"),
	MusicTheme.End: preload("res://assets/sound&music/End.mp3"),
}

func _ready() -> void:
	current_theme = MusicTheme.None
	music_player.finished.connect(_on_music_finished)

func play_background_music(new_music: MusicTheme, fade_time: float = 2.5) -> void:
	print("Request to change music from ", current_theme, " to ", new_music)
	if new_music == current_theme or new_music == MusicTheme.None:
		print("Request denied")
		return
	
	print("Request accepted")
	current_theme = new_music
	music_player.stop()
	music_player.stream = THEMES[new_music]
	_fade_in_music(fade_time)

func play_menu_music(new_music: MusicTheme, fade_time: float = 2.5) -> void:
	pass

func get_current_music():
	return music_player.stream

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

enum MusicTheme {
	None,
	Main,
	Car,
	Puzzle,
	End,
}
