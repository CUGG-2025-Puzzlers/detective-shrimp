class_name SlidePuzzle
extends Control

@export var board_size: Vector2i
@export var tile_size: int

@onready var board: Array[int]
@onready var goal_index: int = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SlidePuzzleEvents.piece_moved.connect(on_piece_moved)
	
	board = []
	board.resize(board_size.x * board_size.y)
	board.fill(Globals.SlidePuzzleValues.Empty)
	size = board_size * tile_size
	
	SlidePuzzleEvents.hide_directions()
	set_up_board()
	print_board()

#region Event Handlers

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			on_mouse_down()

func on_mouse_down() -> void:
	SlidePuzzleEvents.click_board()

func on_piece_moved() -> void:
	await Engine.get_main_loop().process_frame
	print_board()

#endregion

#region Board Setup

func set_up_board() -> void:
	# Loop through children and fill in their positions with their identifiers
	var children = get_children()
	for child in children:
		# Set up the goal position
		if child is SlidePuzzleGoal:
			if goal_index != -1:
				push_error("Multiple goals present on this board, remove all but one")
				continue
				
			var cell: Vector2i = child.position / tile_size
			if (cell.x < 0 or cell.x > board_size.x - 2 or
				cell.y < 0 or cell.y > board_size.y - 1):
				push_error("Goal not within bounds of the board")
				continue
			
			goal_index = cell.y * board_size.x + cell.x
		
		# Skip through all non puzzle piece nodes
		if not child is SlidePuzzlePiece:
			continue
		
		child.set_up(board, board_size, tile_size)

#endregion

# Prints the board to the console as a 2D array
func print_board() -> void:
	print("Board State:")
	for i in range(board_size.x):
		var row = ""
		for j in range(board_size.y):
			row += str(board[i * board_size.x + j]) + " "
		print(row)
