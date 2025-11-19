extends Node

signal selected_direction(pos: Vector2, direction: Globals.Direction)

func select_direction(pos: Vector2, direction: Globals.Direction) -> void:
	selected_direction.emit(pos, direction)
