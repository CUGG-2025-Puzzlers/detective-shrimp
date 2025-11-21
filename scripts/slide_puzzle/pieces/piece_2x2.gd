class_name Piece2x2
extends SlidePuzzlePiece

#region Setup

func _ready() -> void:
	super._ready()
	indicator = Globals.SlidePuzzleValues.Indicator2x2
	filler = Globals.SlidePuzzleValues.Filler2x2

func is_in_bounds(board_size: Vector2i, tile_size: int) -> bool:
	var pos: Vector2i = position / tile_size
	return (pos.x >= 0 and pos.x < board_size.x - 1 and
			pos.y >= 0 and pos.y < board_size.y - 1)

func would_overlap(board: Array[int], board_width: int) -> bool:
	if index == -1:
		print("Index not set, cannot check overlap, defaulting to true")
		return true
	
	return (board[index] != Globals.SlidePuzzleValues.Empty and
			board[index + 1] != Globals.SlidePuzzleValues.Empty and
			board[index + board_width] != Globals.SlidePuzzleValues.Empty and
			board[index + board_width + 1] != Globals.SlidePuzzleValues.Empty)

func add_to_board(board: Array[int], board_width: int) -> void:
	if board[index] != Globals.SlidePuzzleValues.Empty:
		return
	
	board[index] = indicator
	board[index + 1] = filler
	board[index + board_width] = filler
	board[index + board_width + 1] = filler

#endregion

#region Movement Check

func can_move_up(board: Array[int], board_width: int) -> bool:
	if index - board_width >= 0:
		return (board[index - board_width] == Globals.SlidePuzzleValues.Empty and
				board[index - board_width + 1] == Globals.SlidePuzzleValues.Empty)
	
	return false

func can_move_right(board: Array[int], board_width: int) -> bool:
	if (index + 1) % board_width != 0:
		return (board[index + 2] == Globals.SlidePuzzleValues.Empty and
				board[index + board_width + 2] == Globals.SlidePuzzleValues.Empty)
	
	return false

func can_move_down(board: Array[int], board_width: int) -> bool:
	if index + board_width < board.size():
		return (board[index + 2 * board_width] == Globals.SlidePuzzleValues.Empty and
				board[index + 2 * board_width + 1] == Globals.SlidePuzzleValues.Empty)
	
	return false

func can_move_left(board: Array[int], board_width: int) -> bool:
	if index % board_width != 0:
		return (board[index - 1] == Globals.SlidePuzzleValues.Empty and
				board[index + board_width - 1] == Globals.SlidePuzzleValues.Empty)
	
	return false

#endregion

#region Movement

func _move_up(board: Array[int], board_width: int) -> void:
	board[index - board_width] = indicator
	board[index - board_width + 1] = filler
	board[index] = filler
	
	board[index + board_width] = Globals.SlidePuzzleValues.Empty
	board[index + board_width + 1] = Globals.SlidePuzzleValues.Empty

func _move_right(board: Array[int], board_width: int) -> void:
	board[index + 1] = indicator
	board[index + 2] = filler
	board[index + board_width + 2] = filler
	
	board[index] = Globals.SlidePuzzleValues.Empty
	board[index + board_width] = Globals.SlidePuzzleValues.Empty

func _move_down(board: Array[int], board_width: int) -> void:
	board[index + board_width] = indicator
	board[index + 2 * board_width] = filler
	board[index + 2 * board_width + 1] = filler
	
	board[index] = Globals.SlidePuzzleValues.Empty
	board[index + 1] = Globals.SlidePuzzleValues.Empty

func _move_left(board: Array[int], board_width: int) -> void:
	board[index - 1] = indicator
	board[index + board_width - 1] = filler
	board[index] = filler
	
	board[index + 1] = Globals.SlidePuzzleValues.Empty
	board[index + board_width + 1] = Globals.SlidePuzzleValues.Empty

#endregion
