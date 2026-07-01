class_name GameScene
extends Node

@export var background_music: AudioManager.MusicTheme
@export var spawn_points: Array[Marker2D]

func _ready() -> void:
	AudioManager.play_background_music(background_music)

func set_player_location(player: Player, location_id: int) -> void:
	if location_id < 0 or spawn_points.size() <= location_id:
		var error = "Could not set player position to location %d: Index out of bounds"
		push_error(error)
		print(error)
		return
	
	player.position = spawn_points[location_id].position
	print("Player location set")
