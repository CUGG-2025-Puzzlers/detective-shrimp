@abstract class_name SlidePuzzlePiece
extends TextureRect

@onready var index = -1
@onready var indicator = -1
@onready var filler = -1

#region Abstract functions

@abstract func is_in_bounds(board_size: Vector2i, tile_size: int) -> bool
@abstract func would_overlap(board: Array[int], board_width: int) -> bool
@abstract func add_to_board(board: Array[int], board_width: int) -> void

@abstract func can_move_up(board: Array[int], board_width: int) -> bool
@abstract func can_move_right(board: Array[int], board_width: int) -> bool
@abstract func can_move_down(board: Array[int], board_width: int) -> bool
@abstract func can_move_left(board: Array[int], board_width: int) -> bool

@abstract func _move_up(board: Array[int], board_width: int) -> void
@abstract func _move_right(board: Array[int], board_width: int) -> void
@abstract func _move_down(board: Array[int], board_width: int) -> void
@abstract func _move_left(board: Array[int], board_width: int) -> void

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

func set_up(board: Array[int], board_size: Vector2i, tile_size: int) -> void:
	if not is_in_bounds(board_size, tile_size):
		print("Piece (", name, ") is not within the puzzle bounds, hiding it")
		hide()
	
	var pos: Vector2i = position / tile_size
	index = pos.y * board_size.x + pos.x
	print(name, " at index ", index)
	
	if would_overlap(board, board_size.x):
		print("Piece (", name, ") would overlap another piece, hiding it instead")
		hide()
	
	add_to_board(board, board_size.x)

#endregion

#region Event Handlers

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			_on_mouse_down()

func _on_mouse_down() -> void:
	SlidePuzzleEvents.click_piece()
	var parent = get_parent()
	try_move_piece(parent.board, parent.board_size.x)

func _on_puzzle_started() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP

func _on_puzzle_completed() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_selected_direction(direction: Globals.Direction) -> void:
	print("Selected Direction")
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

func try_move_piece(board: Array[int], board_width: int) -> void:
	var possible_moves = get_possible_moves(board, board_width)
	
	# No possible moves, do nothing
	if possible_moves.size() == 0:
		print("This piece cannot move")
		return
	
	# Only one possible move, do it
	if possible_moves.size() == 1:
		move(possible_moves[0])
		return
	
	# Multiple possible moves, ask user
	SlidePuzzleEvents.request_directions(position, possible_moves)
	SlidePuzzleEvents.directions_selected.connect(_on_selected_direction)

func get_possible_moves(board: Array[int], board_width: int) -> Array[Globals.Direction]:
	var possible_moves: Array[Globals.Direction] = []
	
	# Check each direction for possible movement
	if can_move_up(board, board_width):
		possible_moves.append(Globals.Direction.Up)
	if can_move_right(board, board_width):
		possible_moves.append(Globals.Direction.Right)
	if can_move_down(board, board_width):
		possible_moves.append(Globals.Direction.Down)
	if can_move_left(board, board_width):
		possible_moves.append(Globals.Direction.Left)
	
	return possible_moves

func move(direction: Globals.Direction) -> void:
	var board = get_parent().board
	var board_width = get_parent().board_size.x
	
	match direction:
		Globals.Direction.Up:
			_move_up(board, board_width)
			index -= board_width
		Globals.Direction.Right:
			_move_right(board, board_width)
			index += 1
		Globals.Direction.Down:
			_move_down(board, board_width)
			index += board_width
		Globals.Direction.Left:
			_move_left(board, board_width)
			index -= 1
		
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
