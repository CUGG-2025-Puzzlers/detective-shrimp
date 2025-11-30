class_name SlidePuzzle
extends Control

@export var board_size: Vector2i
@export var tile_size: int

@onready var board
@onready var goal: Vector2i = Vector2i(-1, -1)

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
	size = board_size * tile_size
	
	SlidePuzzleEvents.hide_directions()
	set_up_board()
	print_board()
	start()

#region Event Handlers

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			on_mouse_down()

func on_mouse_down() -> void:
	SlidePuzzleEvents.click_board()

func on_piece_moved() -> void:
	print_board()
	
	# Check for win state
	if (board[goal.x][goal.y] == Globals.SlidePuzzleValues.IndicatorKey and 
		board[goal.x + 1][goal.y] == Globals.SlidePuzzleValues.IndicatorKey):
		complete()

#endregion

#region Board Setup

func set_up_board() -> void:
	# Loop through children and fill in their positions with their identifiers
	var children = get_children()
	for child in children:
		# Set up the goal position
		if child is SlidePuzzleGoal:
			if goal.x != -1:
				push_error("Multiple goals present on this board, remove all but one")
				continue
				
			if not child.is_in_bounds(board_size, tile_size):
				push_error("Goal not within bounds of the board")
				continue
			
			goal = child.position / tile_size
		
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
