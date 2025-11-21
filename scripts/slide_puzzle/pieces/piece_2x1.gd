class_name Piece2x1
extends SlidePuzzlePiece

#region Setup

func _ready() -> void:
	super._ready()
	indicator = Globals.SlidePuzzleValues.Indicator2x1
	filler = Globals.SlidePuzzleValues.Filler2x1

func is_in_bounds(board_size: Vector2i, tile_size: int) -> bool:
	var pos: Vector2i = position / tile_size
	return (pos.x >= 0 and pos.x < board_size.x and
			pos.y >= 0 and pos.y < board_size.y - 1)

func would_overlap(board: Array[int], board_width: int) -> bool:
	if index == -1:
		print("Index not set, cannot check overlap, defaulting to true")
		return true
	
	return (board[index] != Globals.SlidePuzzleValues.Empty and
			board[index + board_width] != Globals.SlidePuzzleValues.Empty)

func add_to_board(board: Array[int], board_width: int) -> void:
	if board[index] != Globals.SlidePuzzleValues.Empty:
		return
	
	board[index] = Globals.SlidePuzzleValues.Indicator2x1
	board[index + board_width] = Globals.SlidePuzzleValues.Filler2x1

#endregion

#region Movement Checks

func can_move_up(board: Array[int], board_width: int) -> bool:
	if index - board_width >= 0:
		return board[index - board_width] == Globals.SlidePuzzleValues.Empty
	
	return false

func can_move_right(board: Array[int], board_width: int) -> bool:
	if (index + 1) % board_width != 0:
		return (board[index + 1] == Globals.SlidePuzzleValues.Empty and
				board[index + board_width + 1] == Globals.SlidePuzzleValues.Empty)
	
	return false

func can_move_down(board: Array[int], board_width: int) -> bool:
	if index + 2 * board_width < board.size():
		return board[index + 2 * board_width] == Globals.SlidePuzzleValues.Empty
	
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
	board[index] = filler
	
	board[index + board_width] = Globals.SlidePuzzleValues.Empty

func _move_right(board: Array[int], board_width: int) -> void:
	board[index + 1] = indicator
	board[index + board_width + 1] = filler
	
	board[index] = Globals.SlidePuzzleValues.Empty
	board[index + board_width] = Globals.SlidePuzzleValues.Empty

func _move_down(board: Array[int], board_width: int) -> void:
	board[index + board_width] = indicator
	board[index + 2 * board_width] = filler
	
	board[index] = Globals.SlidePuzzleValues.Empty

func _move_left(board: Array[int], board_width: int) -> void:
	board[index - 1] = indicator
	board[index + board_width - 1] = filler
	
	board[index] = Globals.SlidePuzzleValues.Empty
	board[index + board_width] = Globals.SlidePuzzleValues.Empty

#endregion
