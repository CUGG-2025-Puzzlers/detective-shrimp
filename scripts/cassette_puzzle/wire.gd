class_name Wire
extends TextureRect

@export var max_length: int

@onready var wire : WireLine

signal stateChanged;

var state = null
var dragging = false
var hovered_input: GateInput = null
var connected_input: GateInput = null
var on_color: Color = Color(0, 0.2, 1)
var off_color: Color = Color(1, 0, 0.2)

func _ready() -> void:
	# Set WireLine reference to child
	wire = $Wire_Line
	set_wire_color()

func _process(delta: float) -> void:
	# Wire follows mouse while dragging
	if dragging:
		wire.adjust()

#region Event Handlers

# Check for GUI Input events
func _gui_input(event: InputEvent) -> void:
	# Checking for Mouse Button Left events
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			_on_mouse_down()
		elif event.is_released():
			_on_mouse_up()

# Mouse Button Left clicked: Start the wire dragging
func _on_mouse_down():
	mouse_default_cursor_shape = Control.CURSOR_DRAG
	
	# Clear any previous connections
	disconnect_from_input()
	
	# Start new wire
	wire.start()
	CasettePuzzleEvents.hovered_input.connect(_on_hovered_input)
	CasettePuzzleEvents.unhovered_input.connect(_on_unhovered_input)
	dragging = true

# Mouse Button Left let go: Stop the wire dragging and connect if possible
func _on_mouse_up():
	dragging = false
	CasettePuzzleEvents.hovered_input.disconnect(_on_hovered_input)
	CasettePuzzleEvents.unhovered_input.disconnect(_on_unhovered_input)
	
	# Clear wire if not hovering over reachable input connection
	if hovered_input == null:
		mouse_default_cursor_shape = Control.CURSOR_ARROW
		wire.clear()
		return
	
	# Connect wire
	mouse_default_cursor_shape = Control.CURSOR_MOVE
	connect_to_input()

func _on_mouse_entered():
	if dragging:
		return
	
	mouse_default_cursor_shape = Control.CURSOR_MOVE

func _on_mouse_exited():
	if dragging:
		return
	
	mouse_default_cursor_shape = Control.CURSOR_ARROW

# Set the hovered input connection reference if in reach
func _on_hovered_input(input: GateInput) -> void:
	if can_reach(input) and get_parent() != input.get_parent():
		hovered_input = input

# Clear the hovered input connection reference
func _on_unhovered_input() -> void:
	hovered_input = null

#endregion

# Sets the wire's color based on the state
func set_wire_color():
	if state == null:
		wire.default_color = Color.WHITE
		self_modulate = Color.WHITE
		return
	
	wire.default_color = on_color if state else off_color
	self_modulate = on_color if state else off_color

# Changes the state of this wire if the new state is different than the current
func change_state(newState):
	if state == newState:
		return
	
	state = newState
	set_wire_color()
	stateChanged.emit()

# Checks if the wire can reach a specified GateInput
func can_reach(input: GateInput):
	var wire_start = wire.global_position
	var input_edge = input.global_position
	input_edge.y += input.size.y / 2
	
	return wire_start.distance_to(input_edge) <= max_length

# Connects to the hovered Gate Input
func connect_to_input():
	if hovered_input == null:
		return
	
	# Hovered input is already connected to another wire
	if hovered_input.wire != null:
		wire.clear()
		return
	
	wire.attach(hovered_input)
	hovered_input.connect_wire(self)
	connected_input = hovered_input
	hovered_input = null

# Disconnects from the connected Gate Input
func disconnect_from_input():
	if connected_input == null:
		return
	
	wire.clear()
	connected_input.disconnect_wire()
	connected_input = null
