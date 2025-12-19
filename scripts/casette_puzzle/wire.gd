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
	
	# Clear wire if not hovering over input connection
	if hovered_input == null:
		wire.clear()
		return
	
	# Connect wire if hovering over input connection
	'''Acount for wire offset'''
	var input_edge = hovered_input.position
	input_edge.y += hovered_input.size.y / 2
	var input_center = hovered_input.position + hovered_input.size / 2
	wire.attach(input_edge, input_center)

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
