@tool
class_name Reflector
extends Node2D

@export var type: Type:
	set(value):
		type = value
		_set_orientation()

@onready var light_reflector: Area2D = %LightReflector
@onready var clickable_area: Area2D = %ClickableArea

const GRID_CELL_SIZE: int = 16
const HALF_GRID_SIZE: Vector2 = Vector2(8, 8)

var hovering: bool = false
var dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO

func _ready() -> void:
	_set_orientation()
	clickable_area.input_event.connect(_on_clickable_area_input_event)
	clickable_area.mouse_entered.connect(_on_mouse_entered)
	clickable_area.mouse_exited.connect(_on_mouse_exited)

func _process(_delta: float) -> void:
	if not hovering:
		if dragging:
			_on_mouse_up()
			_on_mouse_exited()
			dragging = false
		
		return
	
	# Ensure the cursor is set correctly when hovering over this reflector
	# Needed when quickly moving between reflectors and the second reflector's
	# on_mouse_entered is called before the first reflector's on_mouse_exited
	if not dragging and not Input.get_current_cursor_shape() == Input.CURSOR_MOVE:
		Input.set_default_cursor_shape(Input.CURSOR_MOVE)
		return
	
	if dragging:
		# Ensure the cursor is set correctly when dragging this reflector
		# Needed when quickly moving between reflectors and the second reflector's
		# on_mouse_entered is called before the first reflector's on_mouse_exited
		if not Input.get_current_cursor_shape() == Input.CURSOR_DRAG:
			Input.set_default_cursor_shape(Input.CURSOR_DRAG)
		
		global_position = get_global_mouse_position() + drag_offset

func _set_orientation() -> void:
	if light_reflector == null:
		return
	
	match type:
		Type.Forward:
			light_reflector.rotation_degrees = 135.0
		Type.Backward:
			light_reflector.rotation_degrees = 45.0
		_:
			light_reflector.rotation_degrees = 0.0

func _on_clickable_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_released():
			_on_mouse_up()
		elif event.is_pressed():
			_on_mouse_down()

func _on_mouse_entered() -> void:
	hovering = true
	Input.set_default_cursor_shape(Input.CURSOR_MOVE)

func _on_mouse_exited() -> void:
	hovering = false
	drag_offset = Vector2.ZERO
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _on_mouse_down() -> void:
	dragging = true
	drag_offset = global_position - get_global_mouse_position()
	Input.set_default_cursor_shape(Input.CURSOR_DRAG)

func _on_mouse_up() -> void:
	dragging = false
	_snap_position()
	Input.set_default_cursor_shape(Input.CURSOR_MOVE)

func _snap_position() -> void:
	position = ((position - drag_offset) / GRID_CELL_SIZE).floor() * GRID_CELL_SIZE + HALF_GRID_SIZE

func reflect(dir: Globals.Direction) -> Globals.Direction:
	if type == Type.None:
		return dir
	
	match dir:
		Globals.Direction.Left:
			return Globals.Direction.Down if type == Type.Forward else Globals.Direction.Up
		Globals.Direction.Right:
			return Globals.Direction.Up if type == Type.Forward else Globals.Direction.Down
		Globals.Direction.Up:
			return Globals.Direction.Right if type == Type.Forward else Globals.Direction.Left
		Globals.Direction.Down:
			return Globals.Direction.Left if type == Type.Forward else Globals.Direction.Right
		_:
			return dir

enum Type {
	None,
	Forward,
	Backward
}
