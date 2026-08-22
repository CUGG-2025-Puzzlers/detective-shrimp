class_name SlidePuzzlePiece
extends TextureRect

@export var shape: Array[Array]
@export var indicator: Globals.SlidePuzzleValues
@export var moveable: bool = true

var dragging: bool = false
var clicked_cell_offset: Vector2i
var board: SlidePuzzleBoard = null

#region Setup

func _ready() -> void:
	# Hide pieces not part of a slide puzzle
	if not get_parent() is SlidePuzzleBoard:
		print("Piece (", name, ") is not part of a puzzle, hiding it")
		hide()
		return
	
	board = get_parent()
	mouse_default_cursor_shape = Control.CURSOR_MOVE

#endregion

#region Event Handlers

# Checks for mouse movement only if dragging
func _process(delta: float) -> void:
	if not dragging:
		return
	
	try_drag()

# Checks for clicks on this node to toggle dragging
func _gui_input(event: InputEvent) -> void:
	if not moveable:
		return
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			_on_mouse_down()
		elif event.is_released():
			_on_mouse_up()

# Begins dragging on click
func _on_mouse_down() -> void:
	var piece_cell = get_piece_cell()
	var mouse_cell = get_mouse_cell()
	clicked_cell_offset = mouse_cell - piece_cell
	
	if shape[clicked_cell_offset.y][clicked_cell_offset.x] == 0:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		var mouse_pos = get_global_mouse_position()
		Globals.resend_mouse_click(mouse_pos, true)
		await get_tree().process_frame
		mouse_filter = Control.MOUSE_FILTER_STOP
		return
	
	dragging = true
	mouse_default_cursor_shape = Control.CURSOR_DRAG

# Stops dragging on release
func _on_mouse_up() -> void:
	dragging = false
	mouse_default_cursor_shape = Control.CURSOR_MOVE

# Allows clicking while puzzle is active
# Listens for puzzle completion
func _on_puzzle_started() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	GameEvents.puzzle_complete_requested.connect(_on_puzzle_completed)

# Ignores clicking once puzzle is complete
# Stops listening for puzzle completion
func _on_puzzle_completed() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	dragging = false
	GameEvents.puzzle_complete_requested.disconnect(_on_puzzle_completed)

#endregion

#region Movement

# Attempts to move the piece in the direction of the mouse
func try_drag():
	if not dragging or not moveable:
		return
	
	# Find relative direction of mouse in cell units
	var piece_cell = get_piece_cell()
	var mouse_cell = get_mouse_cell()
	var direction = mouse_cell - piece_cell - clicked_cell_offset
	
	# Try to drag in the direction we're attempting to
	# Up
	if direction.y < 0 and board.can_move(self, Globals.Direction.Up):
		board.move(self, Globals.Direction.Up)
		return
	
	# Right
	if direction.x > 0 and board.can_move(self, Globals.Direction.Right):
		board.move(self, Globals.Direction.Right)
		return
	
	# Down
	if direction.y > 0 and board.can_move(self, Globals.Direction.Down):
		board.move(self, Globals.Direction.Down)
		return
	
	# Left
	if direction.x < 0 and board.can_move(self, Globals.Direction.Left):
		board.move(self, Globals.Direction.Left)
		return

#endregion

# Returns a Vector2i representing the cell on the board that this piece is in
# This cell is the top-leftmost cell of the piece, even if the shape is empty there
func get_piece_cell() -> Vector2i:
	return position / board.TILE_SIZE

# Returns a Vector2i representing the cell on the board that the cursor is hovering
func get_mouse_cell() -> Vector2i:
	var tile_size = board.TILE_SIZE
	var mouse_board_pos = get_global_mouse_position() - board.global_position
	return mouse_board_pos / tile_size
