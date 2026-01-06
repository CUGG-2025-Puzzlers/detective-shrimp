class_name SlidePuzzlePiece
extends TextureRect

@onready var cell: Vector2i = Vector2i(-1, -1)
@onready var indicator = -1

var dragging: bool = false
var clicked_cell_offset: Vector2i

#region Setup

func _ready() -> void:
	# Hide pieces not part of a slide puzzle
	if not get_parent() is SlidePuzzle:
		print("Piece (", name, ") is not part of a puzzle, hiding it")
		hide()
		return
	
	SlidePuzzleEvents.puzzle_started.connect(_on_puzzle_started)
	SlidePuzzleEvents.puzzle_completed.connect(_on_puzzle_completed)


#endregion

#region Event Handlers

# Checks for mouse movement only if dragging
func _process(delta: float) -> void:
	if not dragging:
		return
	
	try_drag()

# Checks for clicks on this node to toggle dragging
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			_on_mouse_down()
		elif event.is_released():
			_on_mouse_up()

# Begins dragging on click
func _on_mouse_down() -> void:
	var tile_size = get_parent().tile_size
	var mouse_board_pos = get_global_mouse_position() - get_parent().global_position
	var mouse_cell: Vector2i = mouse_board_pos / tile_size
	clicked_cell_offset = mouse_cell - cell
	dragging = true

# Stops dragging on release
func _on_mouse_up() -> void:
	dragging = false

# Allows clicking while puzzle is active
func _on_puzzle_started() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP

# Ignores clicking once puzzle is complete
func _on_puzzle_completed() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	dragging = false

#endregion

#region Movement

# Attempts to move the piece in the direction of the mouse
func try_drag():
	if not dragging:
		return
	
	var board = get_parent().board
	var tile_size = get_parent().tile_size
	
	# Find relative direction of mouse in cell units
	var mouse_board_pos = get_global_mouse_position() - get_parent().global_position
	var mouse_cell: Vector2i = mouse_board_pos / tile_size
	var direction = mouse_cell - cell - clicked_cell_offset
	
	# Try to drag in the direction we're attempting to
	# Up
	if direction.y < 0 and can_move_up(board):
		move(board, Globals.Direction.Up)
		return
	
	# Right
	if direction.x > 0 and can_move_right(board):
		move(board, Globals.Direction.Right)
		return
	
	# Down
	if direction.y > 0 and can_move_down(board):
		move(board, Globals.Direction.Down)
		return
	
	# Left
	if direction.x < 0 and can_move_left(board):
		move(board, Globals.Direction.Left)
		return

# Moves this piece in the given direction
# Updates the board
func move(board, direction: Globals.Direction) -> void:
	match direction:
		Globals.Direction.Up:
			move_up(board)
			cell.y -= 1
		Globals.Direction.Right:
			move_right(board)
			cell.x += 1
		Globals.Direction.Down:
			move_down(board)
			cell.y += 1
		Globals.Direction.Left:
			move_left(board)
			cell.x -= 1
		
	move_texture(direction)

# Updates this piece's position using the given direction
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
