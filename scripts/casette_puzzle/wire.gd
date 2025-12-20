class_name Wire
extends TextureRect

@export var max_length: int

@onready var wire : WireLine

signal stateChanged;

var state = false
var dragging = false
var hovered_input: GateInput = null

func _ready() -> void:
	# Set WireLine reference to child
	wire = $Wire_Line

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
	wire.start()
	CasettePuzzleEvents.hovered_input.connect(_on_hovered_input)
	CasettePuzzleEvents.unhovered_input.connect(_on_unhovered_input)
	dragging = true

# Mouse Button Left let go: Stop the wire dragging
func _on_mouse_up():
	dragging = false
	CasettePuzzleEvents.hovered_input.disconnect(_on_hovered_input)
	CasettePuzzleEvents.unhovered_input.disconnect(_on_unhovered_input)
	
	# Clear wire if not hovering over input connection or can't reach hovered input
	if hovered_input == null or not can_reach(hovered_input):
		wire.clear()
		hovered_input = null
		return
	
	# Connect wire if hovering over reachable input connection
	wire.attach(hovered_input)
	hovered_input = null

# Set the hovered input connection reference
func _on_hovered_input(input: GateInput) -> void:
	hovered_input = input

# Clear the hovered input connection reference
func _on_unhovered_input() -> void:
	hovered_input = null

#endregion

# Changes the state of this wire if the new state is different than the current
func change_state(newState: bool):
	if state == newState:
		return
	
	state = newState
	stateChanged.emit()

# Checks if the wire can reach a specified GateInput
func can_reach(input: GateInput):
	var wire_start = wire.position
	var input_edge = Vector2(input.position.x, input.position.y + input.size.y / 2)
	
	return wire_start.distance_to(input_edge) <= max_length
