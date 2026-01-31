extends Node2D

func _ready():
	# Spawn player near the encrypted letter for testing
	Player.position = Vector2(140, 180)
	Globals.show_player()
