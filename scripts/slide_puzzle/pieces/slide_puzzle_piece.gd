@abstract class_name SlidePuzzlePiece
extends TextureRect

@onready var cell: Vector2i = Vector2i(-1, -1)
@onready var indicator = -1

#region Abstract functions

@abstract func is_in_bounds(board_size: Vector2i, tile_size: int) -> bool
@abstract func would_overlap(board) -> bool
@abstract func add_to_board(board) -> void

@abstract func can_move_up(board) -> bool
@abstract func can_move_right(board) -> bool
@abstract func can_move_down(board) -> bool
@abstract func can_move_left(board) -> bool

@abstract func _move_up(board) -> void
@abstract func _move_right(board) -> void
@abstract func _move_down(board) -> void
@abstract func _move_left(board) -> void

#endregion

#region Setup

func _ready() -> void:
	if not get_parent() is SlidePuzzle:
		print("Piece (", name, ") is not part of a puzzle, hiding it")
		hide()
		return
	
	SlidePuzzleEvents.piece_clicked.connect(_on_piece_clicked)
	SlidePuzzleEvents.puzzle_started.connect(_on_puzzle_started)
	SlidePuzzleEvents.puzzle_completed.connect(_on_puzzle_completed)

func set_up(board, board_size: Vector2i, tile_size: int) -> void:
	if not is_in_bounds(board_size, tile_size):
		print("Piece (", name, ") is not within the puzzle bounds, hiding it")
		hide()
	
	cell = position / tile_size
	print(name, " at cell ", cell.x, ", ", cell.y)
	
	if would_overlap(board):
		print("Piece (", name, ") would overlap another piece, hiding it instead")
		hide()
	
	add_to_board(board)

#endregion

#region Event Handlers

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			_on_mouse_down()

func _on_mouse_down() -> void:
	SlidePuzzleEvents.click_piece()
	var parent = get_parent()
	try_move_piece(parent.board)

func _on_puzzle_started() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP

func _on_puzzle_completed() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_selected_direction(direction: Globals.Direction) -> void:
	move(direction)
	SlidePuzzleEvents.directions_selected.disconnect(_on_selected_direction)

func _on_piece_clicked() -> void:
	if SlidePuzzleEvents.directions_selected.is_connected(_on_selected_direction):
		SlidePuzzleEvents.directions_selected.disconnect(_on_selected_direction)

func _on_hid_directions() -> void:
	if SlidePuzzleEvents.directions_selected.is_connected(_on_selected_direction):
		SlidePuzzleEvents.directions_selected.disconnect(_on_selected_direction)

func _on_requested_directions() -> void:
	if SlidePuzzleEvents.directions_selected.is_connected(_on_selected_direction):
		SlidePuzzleEvents.directions_selected.disconnect(_on_selected_direction)

#endregion

#region Movement

func try_move_piece(board) -> void:
	var possible_moves = get_possible_moves(board)
	
	# No possible moves, do nothing
	if possible_moves.size() == 0:
		print("This piece cannot move")
		return
	
	# Only one possible move, do it
	if possible_moves.size() == 1:
		move(possible_moves[0])
		return
	
	# Multiple possible moves, ask user
	await Engine.get_main_loop().process_frame
	SlidePuzzleEvents.request_directions(position, possible_moves)
	SlidePuzzleEvents.directions_selected.connect(_on_selected_direction)

func get_possible_moves(board) -> Array[Globals.Direction]:
	var possible_moves: Array[Globals.Direction] = []
	
	# Check each direction for possible movement
	if can_move_up(board):
		possible_moves.append(Globals.Direction.Up)
	if can_move_right(board):
		possible_moves.append(Globals.Direction.Right)
	if can_move_down(board):
		possible_moves.append(Globals.Direction.Down)
	if can_move_left(board):
		possible_moves.append(Globals.Direction.Left)
	
	return possible_moves

func move(direction: Globals.Direction) -> void:
	var board = get_parent().board
	
	match direction:
		Globals.Direction.Up:
			_move_up(board)
			cell.y -= 1
		Globals.Direction.Right:
			_move_right(board)
			cell.x += 1
		Globals.Direction.Down:
			_move_down(board)
			cell.y += 1
		Globals.Direction.Left:
			_move_left(board)
			cell.x -= 1
		
	move_texture(direction)
	SlidePuzzleEvents.move_piece()

func move_texture(direction: Globals.Direction) -> void:
	var tile_size = get_parent().tile_size
	match direction:
		Globals.Direction.Up:
			position += Vector2(0, -tile_size)
		Globals.Direction.Right:
			position += Vector2(tile_size, 0)
		Globals.Direction.Down:
			position += Vector2(0, tile_size)
		Globals.Direction.Left:
			position += Vector2(-tile_size, 0)

#endregion
