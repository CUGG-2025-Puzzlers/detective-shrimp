@tool
class_name SlidePuzzle
extends Control

const TILE_SIZE: int = 32

@export var board_size: Vector2i = Vector2i(2, 1) : set = resize_board
@export var goal_pos: Vector2i : set = reposition_goal
@export_tool_button("Set Up Board") var run_board_setup: Callable = set_up_board

@export var board : Array[Array]
@export var pieces : Array[SlidePuzzlePiece]

#region Editor Functions

# Resizes the board in the editor whenever the board size is changed
func resize_board(value: Vector2i) -> void:
	if value.x < 2 or value.y < 1:
		return
	
	board_size = value
	$%Grid.size = value * TILE_SIZE

# Repositions the goal space in the editor whenever the goal position is changed
func reposition_goal(value: Vector2i) -> void:
	if value.x < 0 or value.y < 0:
		return
	
	goal_pos = value
	$%Goal.position = value * TILE_SIZE

# Sets up the board and pieces whenever the editor button is pressed
func set_up_board() -> void:
	# Create 2D board matrix
	board = []
	board.resize(board_size.x)
	for i in range(board_size.x):
		board[i] = []
		board[i].resize(board_size.y)
		board[i].fill(Globals.SlidePuzzleValues.Empty)
	
	pieces = []
	# Loop through children and fill in their positions with their identifiers
	var children = get_children()
	for child in children:
		# Skip all non puzzle piece nodes
		if not child is SlidePuzzlePiece:
			continue
		
		set_up_piece(child)
	
	print_board()

# Sets up an idividual piece
# Hides pieces that are out of bounds or overlapping other pieces
func set_up_piece(piece: SlidePuzzlePiece) -> void:
	var shape = piece.shape
	var cell: Vector2i = piece.position / TILE_SIZE
	
	# Bounds check
	if (cell.x < 0 or cell.x + shape[0].size() > board_size.x or 
		cell.y < 0 or cell.y + shape.size() > board_size.y):
		piece.hide()
		return
	
	# Overlap check
	for i in range(shape.size()):
		for j in range(shape[0].size()):
			# Skip empty spaces in the shape
			if shape[i][j] == 0:
				continue
			
			if board[cell.x + j][cell.y + i] != Globals.SlidePuzzleValues.Empty:
				piece.hide()
				return
	
	# Snap child position to grid
	piece.position = cell * TILE_SIZE
	
	# Add piece to grid
	pieces.append(piece)
	for i in range(shape.size()):
		for j in range(shape[0].size()):
			# Skip empty spaces in the shape
			if shape[i][j] == 0:
				continue
			
			board[cell.x + j][cell.y + i] = piece.indicator

#endregion

# Starts the puzzle immediately
# Start should be called elsewhere in response to an event or something
func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	start()

#region Puzzle Events

# Starts the puzzle and notifies all pieces
func start() -> void:
	SlidePuzzleEvents.start_puzzle()
	for piece in pieces:
		piece._on_puzzle_started()

# Completes this board
func complete() -> void:
	print("You win!")
	SlidePuzzleEvents.complete_puzzle()

#endregion

#region Piece Movement Check

# Checks if the given piece can move in the given direction
func can_move(piece: SlidePuzzlePiece, direction: Globals.Direction) -> bool:
	# Ignore pieces that are not part of this board
	if not piece in pieces:
		return false
	
	var shape = piece.shape
	var cell: Vector2i = piece.position / TILE_SIZE
	
	match direction:
		Globals.Direction.Up:
			return can_move_up(shape, cell)
		Globals.Direction.Right:
			return can_move_right(shape, cell)
		Globals.Direction.Down:
			return can_move_down(shape, cell)
		Globals.Direction.Left:
			return can_move_left(shape, cell)
		_:
			return false

# Checks if the given shape can be moved up from its current position
func can_move_up(shape: Array[Array], cur_cell_pos: Vector2i) -> bool:
	# Shape is on the top edge
	if cur_cell_pos.y == 0:
		return false
	
	# Check if the topmost part of each column can move up
	for col in range(shape[0].size()):
		var row: int = 0
		while row < shape.size() && shape[row][col] == 0:
			row += 1
		
		# Skip empty columns (all 0s)
		# Shouldn't happen but this is here just in case
		if row >= shape.size():
			continue
		
		if board[cur_cell_pos.x + col][cur_cell_pos.y + row - 1] != Globals.SlidePuzzleValues.Empty:
			return false
	
	return true

# Checks if the given shape can be moved right from its current position
func can_move_right(shape: Array[Array], cur_cell_pos: Vector2i) -> bool:
	# Shape is on the right edge
	if cur_cell_pos.x + shape[0].size() + 1 > board_size.x:
		return false
	
	# Check if the rightmost part of each row can move right
	for row in range(shape.size()):
		var col: int = shape[0].size() - 1
		while col >= 0 && shape[row][col] == 0:
			col -= 1
		
		# Skip empty rows (all 0s)
		# Shouldn't happen but this is here just in case
		if col < 0:
			continue
		
		if board[cur_cell_pos.x + col + 1][cur_cell_pos.y + row] != Globals.SlidePuzzleValues.Empty:
			return false
	
	return true

# Checks if the given shape can be moved down from its current position
func can_move_down(shape: Array[Array], cur_cell_pos: Vector2i) -> bool:
	# Shape is on the bottom edge
	if cur_cell_pos.y + shape.size() + 1 > board_size.y:
		return false
	
	# Check if the bottommost part of each column can move down
	for col in range(shape[0].size()):
		var row: int = shape.size() - 1
		while row >= 0 && shape[row][col] == 0:
			row -= 1
		
		# Skip empty columns (all 0s)
		# Shouldn't happen but this is here just in case
		if row < 0:
			continue
		
		if board[cur_cell_pos.x + col][cur_cell_pos.y + row + 1] != Globals.SlidePuzzleValues.Empty:
			return false
	
	return true

# Checks if the given shape can be moved left from its current position
func can_move_left(shape: Array[Array], cur_cell_pos: Vector2i) -> bool:
	# Shape is on the left edge
	if cur_cell_pos.x == 0:
		return false
	
	# Check if the leftmost part of each row can move left
	for row in range(shape.size()):
		var col: int = 0
		while col < shape[0].size() && shape[row][col] == 0:
			col += 1
		
		# Skip empty rows (all 0s)
		# Shouldn't happen but this is here just in case
		if col >= shape[0].size():
			continue
		
		if board[cur_cell_pos.x + col - 1][cur_cell_pos.y + row] != Globals.SlidePuzzleValues.Empty:
			return false
	
	return true

#endregion

#region Piece Movement

# Moves a piece in the given direction if it's part of this board
func move(piece: SlidePuzzlePiece, direction: Globals.Direction) -> void:
	if not piece in pieces:
		return
	
	var shape = piece.shape
	var cell: Vector2i = piece.position / TILE_SIZE
	var indicator = piece.indicator
	
	match direction:
		Globals.Direction.Up:
			move_up(shape, cell, indicator)
			cell.y -= 1
		Globals.Direction.Right:
			move_right(shape, cell, indicator)
			cell.x += 1
		Globals.Direction.Down:
			move_down(shape, cell, indicator)
			cell.y += 1
		Globals.Direction.Left:
			move_left(shape, cell, indicator)
			cell.x -= 1
	
	piece.position = cell * TILE_SIZE
	print_board()
	
	if key_in_goal():
		complete()

# Moves a piece up
func move_up(shape: Array[Array], cur_cell_pos: Vector2i, indicator: Globals.SlidePuzzleValues) -> void:
	# Go by rows from top to bottom
	for row in range(shape.size()):
		for col in range(shape[0].size()):
			var cur_col = cur_cell_pos.x + col
			var cur_row = cur_cell_pos.y + row
			
			move_cell(shape[row][col], indicator, cur_col, cur_row, 0, -1)

# Moves a piece to the right
func move_right(shape: Array[Array], cur_cell_pos: Vector2i, indicator: Globals.SlidePuzzleValues) -> void:
	# Go by columns from right to left
	for col in range(shape[0].size() - 1, -1, -1):
		for row in range(shape.size()):
			var cur_col = cur_cell_pos.x + col
			var cur_row = cur_cell_pos.y + row
			
			move_cell(shape[row][col], indicator, cur_col, cur_row, 1, 0)

# Moves a piece down
func move_down(shape: Array[Array], cur_cell_pos: Vector2i, indicator: Globals.SlidePuzzleValues) -> void:
	# Go by rows from bottom to top
	for row in range(shape.size() - 1, -1, -1):
		for col in range(shape[0].size()):
			var cur_col = cur_cell_pos.x + col
			var cur_row = cur_cell_pos.y + row
			
			move_cell(shape[row][col], indicator, cur_col, cur_row, 0, 1)

# Moves a piece to the left
func move_left(shape: Array[Array], cur_cell_pos: Vector2i, indicator: Globals.SlidePuzzleValues) -> void:
	# Go by columns from left to right
	for col in range(shape[0].size()):
		for row in range(shape.size()):
			var cur_col = cur_cell_pos.x + col
			var cur_row = cur_cell_pos.y + row
			
			move_cell(shape[row][col], indicator, cur_col, cur_row, -1, 0)

# Moves a piece's individual cell
# Row and column modifiers indicate the direction
func move_cell(shape_value: int, indicator: Globals.SlidePuzzleValues, column: int, row: int, column_modifier: int, row_modifier: int):
	if row_modifier != 0 and column_modifier != 0:
		push_error("Row and column modifiers cannot both be non-zero")
	
	if row_modifier == 0 and column_modifier == 0:
		push_error("Row and column modifiers cannot both be zero")
	
	if abs(row_modifier) > 1 or abs(column_modifier) > 1:
		push_error("Row and column modifiers must be -1, 0, or 1")
	
	# Move hole in shape but leave it's previous cell as it is
	if shape_value == 0:
		board[column + column_modifier][row + row_modifier] = Globals.SlidePuzzleValues.Empty
		return
	
	# Move part of piece, leave it's previous cell empty
	board[column][row] = Globals.SlidePuzzleValues.Empty
	board[column + column_modifier][row + row_modifier] = indicator

#endregion

# Checks if the key is in the goal squares
func key_in_goal() -> bool:
	return (board[goal_pos.x][goal_pos.y] == Globals.SlidePuzzleValues.IndicatorKey and
			board[goal_pos.x + 1][goal_pos.y] == Globals.SlidePuzzleValues.IndicatorKey)

# Prints the board to the console as a 2D array
func print_board() -> void:
	var msg = "Board State:\n"
	for i in range(board_size.y):
		for j in range(board_size.x):
			msg += str(board[j][i]) + " "
		msg += "\n"
	
	print(msg)
