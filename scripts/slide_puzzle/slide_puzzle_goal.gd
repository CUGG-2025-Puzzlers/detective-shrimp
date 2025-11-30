class_name SlidePuzzleGoal
extends Control

func is_in_bounds(board_size: Vector2i, tile_size: int) -> bool:
	var cell: Vector2i = position / tile_size
	return (cell.x >= 0 and cell.x < board_size.x - 1 and
			cell.y >= 0 or cell.y < board_size.y)
