extends Control

@export var board_size: Vector2i
@export var tile_size: int
@onready var board: Array[int]
@onready var pieces: Array[SlideBoardPiece]

const INDICATOR_EMPTY = 0
const INDICATOR_GOAL = 1
const INDICATOR_KEY = 2
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
	
	pieces = []
	pieces.resize(board_size.x * board_size.y)
	
	set_up_board()
	
	print("\nBoard:")
	print_board()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		on_mouse_down(event.position)

func on_mouse_down(pos) -> void:
	var clicked_cell: Vector2i = (pos - global_position) / tile_size
	if (clicked_cell.x < 0 || clicked_cell.x >= board_size.x 
	|| clicked_cell.y < 0 || clicked_cell.y >= board_size.y):
		return
	
	print("Clicked cell (", clicked_cell.x, ", ", clicked_cell.y, ")")
	var clicked_index = clicked_cell.y * board_size.x + clicked_cell.x
	if board[clicked_index] == 0:
		print("Clicked on nothing")
		return
	
	try_move_piece(get_indicator_index(clicked_index))

#region Board Setup

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
	
	pieces[index] = piece
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
	
	pieces[index] = piece
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
	
	pieces[index] = piece
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
	
	pieces[index] = piece
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

#endregion

#region Piece Movement

# Checks if the piece at the given position can be moved in any direction
# If no possible moves, does nothing
# If only one possible move, does that move
# If multiple possible moves, asks the user to choose a direction
func try_move_piece(index: int) -> void:
	var possible_moves = []
	
	# Check each direction for possible movement
	if can_move_down(index):
		possible_moves.append(Direction.Down)
	if can_move_left(index):
		possible_moves.append(Direction.Left)
	if can_move_up(index):
		possible_moves.append(Direction.Up)
	if can_move_right(index):
		possible_moves.append(Direction.Right)
	
	# No possible moves, do nothing
	if possible_moves.size() == 0:
		print("This piece cannot move")
		return
	
	# Only one possible move, do it
	if possible_moves.size() == 1:
		match possible_moves[0]:
			Direction.Up:
				move_piece_up(index)
			Direction.Down:
				move_piece_down(index)
			Direction.Left:
				move_piece_left(index)
			Direction.Right:
				move_piece_right(index)
		
		print_board()
		return
	
	# Multiple possible moves, ask user
	print("This piece can move in multiple directions... NYI")

# Moves the piece up, updates the board and pieces arrays
func move_piece_up(index: int):
	match pieces[index].piece_type:
		SlideBoardPiece.PieceType.OneByOne:
			board[index - board_size.x] = INDICATOR_1x1
			board[index] = INDICATOR_EMPTY
		SlideBoardPiece.PieceType.OneByTwo:
			board[index - board_size.x] = INDICATOR_1x2
			board[index - board_size.x + 1] = FILLER_1x2
			board[index] = INDICATOR_EMPTY
			board[index + 1] = INDICATOR_EMPTY
		SlideBoardPiece.PieceType.TwoByOne:
			board[index - board_size.x] = INDICATOR_2x1
			board[index] = FILLER_2x1
			board[index + board_size.x] = INDICATOR_EMPTY
		SlideBoardPiece.PieceType.TwoByTwo:
			board[index - board_size.x] = INDICATOR_2x2
			board[index - board_size.x + 1] = FILLER_2x2
			board[index] = FILLER_2x2
			board[index + board_size.x] = INDICATOR_EMPTY
			board[index + board_size.x + 1] = INDICATOR_EMPTY
	
	move_texture(index, index - board_size.x)
	pieces[index - board_size.x] = pieces[index];
	pieces[index] = null

# Moves the piece down, updates the board and pieces arrays
func move_piece_down(index: int):
	match pieces[index].piece_type:
		SlideBoardPiece.PieceType.OneByOne:
			board[index + board_size.x] = INDICATOR_1x1
			board[index] = INDICATOR_EMPTY
		SlideBoardPiece.PieceType.OneByTwo:
			board[index + board_size.x] = INDICATOR_1x2
			board[index + board_size.x + 1] = FILLER_1x2
			board[index] = INDICATOR_EMPTY
			board[index + 1] = INDICATOR_EMPTY
		SlideBoardPiece.PieceType.TwoByOne:
			board[index + board_size.x] = INDICATOR_2x1
			board[index + 2 * board_size.x] = FILLER_2x1
			board[index] = INDICATOR_EMPTY
		SlideBoardPiece.PieceType.TwoByTwo:
			board[index + board_size.x] = INDICATOR_2x2
			board[index + 2 * board_size.x] = FILLER_2x2
			board[index + 2 * board_size.x + 1] = FILLER_2x2
			board[index] = INDICATOR_EMPTY
			board[index + 1] = INDICATOR_EMPTY
	
	move_texture(index, index + board_size.x)
	pieces[index + board_size.x] = pieces[index];
	pieces[index] = null

# Moves the piece left, updates the board and pieces arrays
func move_piece_left(index: int):
	match pieces[index].piece_type:
		SlideBoardPiece.PieceType.OneByOne:
			board[index - 1] = INDICATOR_1x1
			board[index] = INDICATOR_EMPTY
		SlideBoardPiece.PieceType.OneByTwo:
			board[index - 1] = INDICATOR_1x2
			board[index] = FILLER_1x2
			board[index + 1] = INDICATOR_EMPTY
		SlideBoardPiece.PieceType.TwoByOne:
			board[index - 1] = INDICATOR_2x1
			board[index + board_size.x - 1] = FILLER_2x1
			board[index] = INDICATOR_EMPTY
			board[index + board_size.x] = INDICATOR_EMPTY
		SlideBoardPiece.PieceType.TwoByTwo:
			board[index - 1] = INDICATOR_2x2
			board[index] = FILLER_2x2
			board[index + board_size.x - 1] = FILLER_2x2
			board[index + 1] = INDICATOR_EMPTY
			board[index + board_size.x + 1] = INDICATOR_EMPTY
	
	move_texture(index, index - 1)
	pieces[index - 1] = pieces[index];
	pieces[index] = null

# Moves the piece right, updates the board and pieces arrays
func move_piece_right(index: int):
	match pieces[index].piece_type:
		SlideBoardPiece.PieceType.OneByOne:
			board[index + 1] = INDICATOR_1x1
			board[index] = INDICATOR_EMPTY
		SlideBoardPiece.PieceType.OneByTwo:
			board[index + 1] = INDICATOR_1x2
			board[index + 2] = FILLER_1x2
			board[index] = INDICATOR_EMPTY
		SlideBoardPiece.PieceType.TwoByOne:
			board[index + 1] = INDICATOR_2x1
			board[index + board_size.x + 1] = FILLER_2x1
			board[index] = INDICATOR_EMPTY
			board[index + board_size.x] = INDICATOR_EMPTY
		SlideBoardPiece.PieceType.TwoByTwo:
			board[index + 1] = INDICATOR_2x2
			board[index + 2] = FILLER_2x2
			board[index + board_size.x + 2] = FILLER_2x2
			board[index] = INDICATOR_EMPTY
			board[index + board_size.x] = INDICATOR_EMPTY
	
	move_texture(index, index + 1)
	pieces[index + 1] = pieces[index];
	pieces[index] = null

func move_texture(start_index: int, end_index: int):
	var cell = Vector2i(end_index % board_size.x, end_index / board_size.x)
	pieces[start_index].position = cell * tile_size

#endregion

#region Position Checks

func get_indicator_index(clicked_index: int) -> int:
	if board[clicked_index] == 0:
		return -1
		
	if board[clicked_index] in [INDICATOR_1x1, INDICATOR_1x2, INDICATOR_2x1, INDICATOR_2x2]:
		return clicked_index
	
	match board[clicked_index]:
		FILLER_1x2:
			return clicked_index - 1
		FILLER_2x1:
			return clicked_index - board_size.x
		FILLER_2x2:
			if board[clicked_index - 1] == INDICATOR_2x2:
				return clicked_index - 1
			if board[clicked_index - board_size.x] == INDICATOR_2x2:
				return clicked_index - board_size.x
			if board[clicked_index - board_size.x - 1] == INDICATOR_2x2:
				return clicked_index - board_size.x - 1
			
			return -1
		_:
			return -1
	

# Checks if the piece is touching the left edge of the board
func touching_left_edge(index: int) -> bool:
	return index % 5 == 0

# Checks if the piece is touching the right edge of the board
func touching_right_edge(index: int) -> bool:
	match pieces[index].piece_type:
		SlideBoardPiece.PieceType.OneByOne, SlideBoardPiece.PieceType.TwoByOne:
			return (index + 1) % 5 == 0
		SlideBoardPiece.PieceType.OneByTwo, SlideBoardPiece.PieceType.TwoByTwo:
			return (index + 2) % 5 == 0
		_:
			return false

# Checks if the piece is touching the top edge of the board
func touching_top_edge(index: int) -> bool:
	return index < board_size.x

# Checks if the piece is touching the bottom edge of the board
func touching_bottom_edge(index: int) -> bool:
	match pieces[index].piece_type:
		SlideBoardPiece.PieceType.OneByOne, SlideBoardPiece.PieceType.OneByTwo:
			return index + board_size.x >= board.size()
		SlideBoardPiece.PieceType.TwoByOne, SlideBoardPiece.PieceType.TwoByTwo:
			return index + 2 * board_size.x >= board.size()
		_:
			return false

# Checks if the piece can move left
func can_move_left(index: int) -> bool:
	if touching_left_edge(index):
		return false
	
	match pieces[index].piece_type:
		SlideBoardPiece.PieceType.OneByOne, SlideBoardPiece.PieceType.OneByTwo:
			return board[index - 1] == INDICATOR_EMPTY
		SlideBoardPiece.PieceType.TwoByOne, SlideBoardPiece.PieceType.TwoByTwo:
			return board[index - 1] == INDICATOR_EMPTY && board[index + board_size.x - 1] == INDICATOR_EMPTY
		_:
			return false

# Checks if the piece can move right
func can_move_right(index: int) -> bool:
	if touching_right_edge(index):
		return false
	
	match pieces[index].piece_type:
		SlideBoardPiece.PieceType.OneByOne:
			return board[index + 1] == INDICATOR_EMPTY
		SlideBoardPiece.PieceType.OneByTwo:
			return board[index + 2] == INDICATOR_EMPTY
		SlideBoardPiece.PieceType.TwoByOne:
			return board[index + 1] == INDICATOR_EMPTY && board[index + board_size.x + 1] == INDICATOR_EMPTY
		SlideBoardPiece.PieceType.TwoByTwo:
			return board[index + 2] == INDICATOR_EMPTY && board[index + board_size.x + 2] == INDICATOR_EMPTY
		_:
			return false

# Checks if the piece can move up
func can_move_up(index: int) -> bool:
	if touching_top_edge(index):
		return false
	
	match pieces[index].piece_type:
		SlideBoardPiece.PieceType.OneByOne, SlideBoardPiece.PieceType.TwoByOne:
			return board[index - board_size.x] == INDICATOR_EMPTY
		SlideBoardPiece.PieceType.OneByTwo, SlideBoardPiece.PieceType.TwoByTwo:
			return board[index - board_size.x] == INDICATOR_EMPTY && board[index + 1 - board_size.x] == INDICATOR_EMPTY
		_:
			return false

# Checks if the piece can move down
func can_move_down(index: int) -> bool:
	if touching_bottom_edge(index):
		return false
	
	match pieces[index].piece_type:
		SlideBoardPiece.PieceType.OneByOne:
			return board[index + board_size.x] == INDICATOR_EMPTY
		SlideBoardPiece.PieceType.OneByTwo:
			return board[index + board_size.x] == INDICATOR_EMPTY && board[index + board_size.x + 1] == INDICATOR_EMPTY
		SlideBoardPiece.PieceType.TwoByOne:
			return board[index + 2 * board_size.x] == INDICATOR_EMPTY
		SlideBoardPiece.PieceType.TwoByTwo:
			return board[index + 2 * board_size.x] == INDICATOR_EMPTY && board[index + 2 * board_size.x + 1] == INDICATOR_EMPTY
		_:
			return false

#endregion

func print_board() -> void:
	for i in range(board_size.x):
		var row = ""
		for j in range(board_size.y):
			row += str(board[i * board_size.x + j]) + " "
		print(row)

enum Direction {
	Left,
	Right,
	Up,
	Down,
}
