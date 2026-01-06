@tool
class_name SlidePuzzle
extends Control

const TILE_SIZE: int = 32

@onready var board
@export var board_size: Vector2i = Vector2i(2, 1) : set = resize_board
@export var goal_pos: Vector2i : set = reposition_goal

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SlidePuzzleEvents.piece_moved.connect(on_piece_moved)

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

	# Create 2D board matrix
	board = []
	board.resize(board_size.x)
	for i in range(board_size.x):
		board[i] = []
		board[i].resize(board_size.y)
		board[i].fill(Globals.SlidePuzzleValues.Empty)
	
	# Resize node to encompass entire board
	$Grid.size = board_size * tile_size
	$Goal.position = goal_pos * tile_size
	
	set_up_board()
	print_board()
	start()

#region Event Handlers

func on_piece_moved() -> void:
	print_board()
	

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
