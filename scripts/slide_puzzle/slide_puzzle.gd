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

#region Board Setup

func set_up_board() -> void:
	# Loop through children and fill in their positions with their identifiers
	var children = get_children()
	for child in children:
		# Skip through all non puzzle piece nodes
		if not child is SlidePuzzlePiece:
			continue
		
		child.set_up(board, board_size, tile_size)

func start() -> void:
	SlidePuzzleEvents.start_puzzle()

#endregion

# Completes this board
func complete() -> void:
	print("You win!")
	SlidePuzzleEvents.complete_puzzle()

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
