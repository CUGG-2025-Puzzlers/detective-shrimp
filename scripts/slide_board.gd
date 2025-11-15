extends Control

@export var board_size: Vector2i
@export var tile_size: int
@onready var board: Array[int]

const INDICATOR_1x1 = 3
const INDICATOR_1x2 = 4
const FILLER_1x2 = 5
const INDICATOR_2x1 = 6
const FILLER_2x1 = 7
const INDICATOR_2x2 = 8
const FILLER_2x2 = 9

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	board = []
	board.resize(board_size.x * board_size.y)
	board.fill(0)
	
	set_up_board()
	
	print("\nBoard:")
	print_board()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		on_mouse_down(event.position)

func on_mouse_down(pos):
	print(pos.x, ",",pos.y)

func set_up_board() -> void:
	# Loop through children and fill in their positions with their identifiers
	var children = get_children()
	for child in children:
		# Skip through all non board piece nodes
		if not child is SlideBoardPiece:
			continue
		
		set_up_piece(child)

# Attempts to add a piece to the board
func set_up_piece(piece: SlideBoardPiece):
	var pos: Vector2i = piece.position / tile_size
	print(piece.name, " (", pos.x, ",", pos.y, ")")
	
	# Initial out of bounds check
	if pos.x < 0 || pos.x >= board_size.x || pos.y < 0 || pos.y >= board_size.y:
		hide_oob(piece)
		return
	
	var index = pos.x + board_size.x * pos.y
	match piece.piece_type:
		SlideBoardPiece.PieceType.OneByOne:
			set_up_1x1(piece, index)
		SlideBoardPiece.PieceType.OneByTwo:
			set_up_1x2(piece, index)
		SlideBoardPiece.PieceType.TwoByOne:
			set_up_2x1(piece, index)
		SlideBoardPiece.PieceType.TwoByTwo:
			set_up_2x2(piece, index)

# Attempts to add a square piece that is 1 tall and 1 wide
func set_up_1x1(piece: SlideBoardPiece, index: int):
	# Overlap check
	if board[index] != 0:
		hide_overlap(piece)
		return
	
	board[index] = INDICATOR_1x1

# Attempts to add a square piece that is 1 tall and 2 wide
func set_up_1x2(piece: SlideBoardPiece, index: int):
	# Out of bounds check
	if (index + 1) % board_size.x == 0:
		hide_oob(piece)
		return
	
	# Overlap check
	if board[index] != 0 || board[index + 1] != 0:
		hide_overlap(piece)
		return
	
	board[index] = INDICATOR_1x2
	board[index + 1] = FILLER_1x2

# Attempts to add a square piece that is 2 tall and 1 wide
func set_up_2x1(piece: SlideBoardPiece, index: int):
	# Out of bounds check
	if index + board_size.x >= board.size():
		hide_oob(piece)
		return
	
	# Overlap check
	if board[index] != 0 || board[index + board_size.x] != 0:
		hide_overlap(piece)
		return
	
	board[index] = INDICATOR_2x1
	board[index + board_size.x] = FILLER_2x1

# Attempts to add a square piece that is 2 tall and 2 wide
func set_up_2x2(piece: SlideBoardPiece, index: int):
	# Out of bounds check
	if (index + 1) % board_size.x == 0 || index + board_size.x >= board.size():
		hide_oob(piece)
		return
	
	# Overlap check
	if board[index] != 0 || board[index + 1] != 0 || board[index + board_size.x] || board[index + board_size.x + 1]:
		hide_overlap(piece)
		return
	
	board[index] = INDICATOR_2x2
	board[index + 1] = FILLER_2x2
	board[index + board_size.x] = FILLER_2x2
	board[index + board_size.x + 1] = FILLER_2x2

# Hide an out of bounds piece and print a message
func hide_oob(piece):
	print (piece.name, " is out of bounds, hiding it")
	piece.visible = false

# Hide an overlapping piece and print a message
func hide_overlap(piece):
	print("Cannot place ", piece.name, " on top of another piece, hiding it instead")
	piece.visible = false

func print_board() -> void:
	for i in range(board_size.x):
		var row = ""
		for j in range(board_size.y):
			row += str(board[i * board_size.x + j]) + " "
		print(row)
