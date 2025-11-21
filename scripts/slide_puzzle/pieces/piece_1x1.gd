class_name Piece1x1
extends SlidePuzzlePiece

#region Setup

func _ready() -> void:
	super._ready()
	indicator = Globals.SlidePuzzleValues.Indicator1x1

func is_in_bounds(board_size: Vector2i, tile_size: int) -> bool:
	var pos: Vector2i = position / tile_size
	return (pos.x >= 0 and pos.x < board_size.x and
			pos.y >= 0 and pos.y < board_size.y)

func would_overlap(board: Array[int], board_width: int) -> bool:
	if index == -1:
		print("Index not set, cannot check overlap, defaulting to true")
		return true
	
	return board[index] != Globals.SlidePuzzleValues.Empty

func add_to_board(board: Array[int], board_width: int) -> void:
	if board[index] != Globals.SlidePuzzleValues.Empty:
		return
	
	board[index] = indicator

#endregion

#region Movement Checks

func can_move_up(board: Array[int], board_width: int) -> bool:
	if index - board_width >= 0:
		return board[index - board_width] == Globals.SlidePuzzleValues.Empty
	
	return false

func can_move_right(board: Array[int], board_width: int) -> bool:
	if (index + 1) % board_width != 0:
		return board[index + 1] == Globals.SlidePuzzleValues.Empty
	
	return false

func can_move_down(board: Array[int], board_width: int) -> bool:
	if index + board_width < board.size():
		return board[index + board_width] == Globals.SlidePuzzleValues.Empty
	
	return false

func can_move_left(board: Array[int], board_width: int) -> bool:
	if index % board_width != 0:
		return board[index - 1] == Globals.SlidePuzzleValues.Empty
	
	return false

#endregion

#region Movement

func _move_up(board: Array[int], board_width: int) -> void:
	board[index - board_width] = indicator
	board[index] = Globals.SlidePuzzleValues.Empty

func _move_right(board: Array[int], board_width: int) -> void:
	board[index + 1] = indicator
	board[index] = Globals.SlidePuzzleValues.Empty

func _move_down(board: Array[int], board_width: int) -> void:
	board[index + board_width] = indicator
	board[index] = Globals.SlidePuzzleValues.Empty

func _move_left(board: Array[int], board_width: int) -> void:
	board[index - 1] = indicator
	board[index] = Globals.SlidePuzzleValues.Empty

#endregion
