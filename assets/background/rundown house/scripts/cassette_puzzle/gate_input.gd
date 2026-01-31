class_name GateInput
extends TextureRect

signal state_changed

var wire: Wire
var old_wire: Wire
var enabled: bool

func _ready() -> void:
	enabled = true
	CassettePuzzleEvents.puzzle_completed.connect(_on_puzzle_completed)

#region Event Handlers

# Check for GUI Input events
func _gui_input(event: InputEvent) -> void:
	if not enabled:
		return
	
	# Checking for Mouse Button Left events
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			_on_mouse_down(event)
		elif event.is_released():
			_on_mouse_up(event)

# Disconnect if connected to a wire:
# Mimic mouse click on that wire to start dragging
# Temporarily store wire reference in another variable to be able to mimic the
# mouse release event as well
# Must be done to mimic BOTH mouse down and up events on the wire node
func _on_mouse_down(event: InputEvent):
	if wire == null:
		return
	
	old_wire = wire
	wire._gui_input(event)
	mouse_default_cursor_shape = Control.CURSOR_DRAG

# If disconnecting an old wire:
# Mimic mouse release event
# Clear old wire reference
func _on_mouse_up(event: InputEvent):
	if old_wire == null:
		return
	
	mouse_default_cursor_shape = Control.CURSOR_ARROW
	old_wire._gui_input(event)
	old_wire = null

# Emits an puzzle event signal when hovering starts
func _on_mouse_entered() -> void:
	CassettePuzzleEvents.hover_input(self)

# Emits an puzzle event signal when hovering stops
func _on_mouse_exited() -> void:
	CassettePuzzleEvents.unhover_input()

# Relays a state change signal when the connected wire changes state
func _on_changed_state():
	print("Connected wire is now ", "null" if (wire == null or wire.state == null)
			else "on" if wire.state else "off")
	state_changed.emit()

func _on_puzzle_completed():
	enabled = false
	mouse_default_cursor_shape = Control.CURSOR_ARROW

#endregion

# Sets the connedted wire and listens for the wire's state change
func connect_wire(new_wire: Wire):
	wire = new_wire
	wire.state_changed.connect(_on_changed_state)
	mouse_default_cursor_shape = Control.CURSOR_MOVE
	_on_changed_state()

# Clears the connected wire and stops listening for the wire's state change
func disconnect_wire():
	wire.state_changed.disconnect(_on_changed_state)
	wire = null
	mouse_default_cursor_shape = Control.CURSOR_ARROW
	_on_changed_state()
