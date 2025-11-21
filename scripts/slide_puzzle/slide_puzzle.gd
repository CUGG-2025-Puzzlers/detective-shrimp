class_name SlidePuzzle
extends Control

@export var board_size: Vector2i
@export var tile_size: int

@onready var board: Array[int]

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

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			_on_mouse_down()

#region Event Handlers

func _on_mouse_down():
	pass

func on_piece_moved() -> void:
	await Engine.get_main_loop().process_frame
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

#endregion

# Prints the board to the console as a 2D array
func print_board() -> void:
	print("Board State:")
	for i in range(board_size.x):
		var row = ""
		for j in range(board_size.y):
			row += str(board[i * board_size.x + j]) + " "
		print(row)
