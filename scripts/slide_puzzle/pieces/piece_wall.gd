class_name WallPiece
extends Piece1x1

func _ready() -> void:
	super._ready()
	indicator = Globals.SlidePuzzleValues.Wall

func can_move_up(board) -> bool:
	return false

func can_move_right(board) -> bool:
	return false

func can_move_down(board) -> bool:
	return false

func can_move_left(board) -> bool:
	return false

func _move_up(board) -> void:
	pass

func _move_right(board) -> void:
	pass

func _move_down(board) -> void:
	pass

func _move_left(board) -> void:
	pass

func move(direction: Globals.Direction) -> void:
	pass

func try_move_piece(board) -> void:
	pass
