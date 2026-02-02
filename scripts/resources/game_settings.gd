@tool
class_name GameSettings
extends Resource

# General
@export var mouse_scale: float = 2.0
@export var music_volume: int = 50:
	set(value):
		value = clampi(value, 0, 100)

# Used in Cassette Puzzle
@export var on_color: Color = Color(0, 0.2, 1)
@export var off_color: Color = Color(1, 0, 0.2)
@export var null_color: Color = Color.WHITE
