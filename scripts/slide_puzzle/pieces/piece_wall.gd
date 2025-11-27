class_name WallPiece
extends Piece1x1

func _ready() -> void:
	super._ready()
	indicator = Globals.SlidePuzzleValues.Wall

func can_move_up(board: Array[int], board_width: int) -> bool:
	return false

func can_move_right(board: Array[int], board_width: int) -> bool:
	return false

func can_move_down(board: Array[int], board_width: int) -> bool:
	return false

func can_move_left(board: Array[int], board_width: int) -> bool:
	return false

func _move_up(board: Array[int], board_width: int) -> void:
	pass

func _move_right(board: Array[int], board_width: int) -> void:
	pass

func _move_down(board: Array[int], board_width: int) -> void:
	pass

func _move_left(board: Array[int], board_width: int) -> void:
	pass

func move(direction: Globals.Direction) -> void:
	pass

func try_move_piece(board: Array[int], board_width: int) -> void:
	pass
