class_name SlidePuzzle
extends Control

@export var board_size: Vector2i
@export var goal_pos: Vector2i
@export var tile_size: int

@onready var board

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SlidePuzzleEvents.piece_moved.connect(on_piece_moved)
	
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
	
	# Check for win state
	if (board[goal_pos.x][goal_pos.y] == Globals.SlidePuzzleValues.IndicatorKey and 
		board[goal_pos.x + 1][goal_pos.y] == Globals.SlidePuzzleValues.IndicatorKey):
		complete()

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

# Prints the board to the console as a 2D array
func print_board() -> void:
	print("Board State:")
	for i in range(board_size.y):
		var row = ""
		for j in range(board_size.x):
			row += str(board[j][i]) + " "
		print(row)
