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
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		on_mouse_down(event.position)

func on_mouse_down(pos):
	print(pos.x, ",",pos.y)

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
