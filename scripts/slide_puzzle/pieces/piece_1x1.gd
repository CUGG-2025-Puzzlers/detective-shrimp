class_name Piece1x1
extends SlidePuzzlePiece

# PIECE SHAPE (Xs)
# OOO
# OXO
# OOO

#region Setup

func _ready() -> void:
	super._ready()
	indicator = Globals.SlidePuzzleValues.Indicator1x1

func is_in_bounds(board_size: Vector2i, tile_size: int) -> bool:
	var pos: Vector2i = position / tile_size
	return (pos.x >= 0 and pos.x < board_size.x and
			pos.y >= 0 and pos.y < board_size.y)

func would_overlap(board) -> bool:
	if cell.x == -1:
		print("Cell not set, cannot check overlap, defaulting to true")
		return true
	
	return board[cell.x][cell.y] != Globals.SlidePuzzleValues.Empty

func add_to_board(board) -> void:
	if board[cell.x][cell.y] != Globals.SlidePuzzleValues.Empty:
		return
	
	board[cell.x][cell.y] = indicator

#endregion

#region Movement Checks

func can_move_up(board) -> bool:
	if cell.y > 0:
		return board[cell.x][cell.y - 1] == Globals.SlidePuzzleValues.Empty
	
	return false

func can_move_right(board) -> bool:
	if cell.x < board.size() - 1:
		return board[cell.x + 1][cell.y] == Globals.SlidePuzzleValues.Empty
	
	return false

func can_move_down(board) -> bool:
	if cell.y < board[0].size() - 1:
		return board[cell.x][cell.y + 1] == Globals.SlidePuzzleValues.Empty
	
	return false

func can_move_left(board) -> bool:
	if cell.x > 0:
		return board[cell.x - 1][cell.y] == Globals.SlidePuzzleValues.Empty
	
	return false

#endregion

#region Movement

func move_up(board) -> void:
	board[cell.x][cell.y - 1] = indicator
	board[cell.x][cell.y] = Globals.SlidePuzzleValues.Empty

func move_right(board) -> void:
	board[cell.x + 1][cell.y] = indicator
	board[cell.x][cell.y] = Globals.SlidePuzzleValues.Empty

func move_down(board) -> void:
	board[cell.x][cell.y + 1] = indicator
	board[cell.x][cell.y] = Globals.SlidePuzzleValues.Empty

func move_left(board) -> void:
	board[cell.x - 1][cell.y] = indicator
	board[cell.x][cell.y] = Globals.SlidePuzzleValues.Empty

#endregion
