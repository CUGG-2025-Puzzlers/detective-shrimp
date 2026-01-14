class_name Piece2x1
extends SlidePuzzlePiece

# PIECE SHAPE (Xs)
# OOO
# OXO
# OXO
# OOO

#region Setup

func _ready() -> void:
	super._ready()
	indicator = Globals.SlidePuzzleValues.Indicator2x1

func is_in_bounds(board_size: Vector2i, tile_size: int) -> bool:
	var pos: Vector2i = position / tile_size
	return (pos.x >= 0 and pos.x < board_size.x and
			pos.y >= 0 and pos.y < board_size.y - 1)

func would_overlap(board) -> bool:
	if cell.x == -1:
		print("Index not set, cannot check overlap, defaulting to true")
		return true
	
	return (board[cell.x][cell.y] != Globals.SlidePuzzleValues.Empty and
			board[cell.x][cell.y + 1] != Globals.SlidePuzzleValues.Empty)

func add_to_board(board) -> void:
	if cell.x == -1:
		print("Index not set, cannot add to board")
		return
	
	board[cell.x][cell.y] = indicator
	board[cell.x][cell.y + 1] = indicator

#endregion

#region Movement Checks

func can_move_up(board) -> bool:
	if cell.y > 0:
		return board[cell.x][cell.y - 1] == Globals.SlidePuzzleValues.Empty
	
	return false

func can_move_right(board) -> bool:
	if cell.x < board.size() - 1:
		return (board[cell.x + 1][cell.y] == Globals.SlidePuzzleValues.Empty and
				board[cell.x + 1][cell.y + 1] == Globals.SlidePuzzleValues.Empty)
	
	return false

func can_move_down(board) -> bool:
	if cell.y < board[0].size() - 2:
		return board[cell.x][cell.y + 2] == Globals.SlidePuzzleValues.Empty
	
	return false

func can_move_left(board) -> bool:
	if cell.x > 0:
		return (board[cell.x - 1][cell.y] == Globals.SlidePuzzleValues.Empty and
				board[cell.x - 1][cell.y + 1] == Globals.SlidePuzzleValues.Empty)
	
	return false

#endregion

#region Movement

func move_up(board) -> void:
	board[cell.x][cell.y - 1] = indicator
	
	board[cell.x][cell.y + 1] = Globals.SlidePuzzleValues.Empty

func move_right(board) -> void:
	board[cell.x + 1][cell.y] = indicator
	board[cell.x + 1][cell.y + 1] = indicator
	
	board[cell.x][cell.y] = Globals.SlidePuzzleValues.Empty
	board[cell.x][cell.y + 1] = Globals.SlidePuzzleValues.Empty

func move_down(board) -> void:
	board[cell.x][cell.y + 2] = indicator
	
	board[cell.x][cell.y] = Globals.SlidePuzzleValues.Empty

func move_left(board) -> void:
	board[cell.x - 1][cell.y] = indicator
	board[cell.x - 1][cell.y + 1] = indicator
	
	board[cell.x][cell.y] = Globals.SlidePuzzleValues.Empty
	board[cell.x][cell.y + 1] = Globals.SlidePuzzleValues.Empty

#endregion
