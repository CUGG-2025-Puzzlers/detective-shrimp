class_name GateInput
extends TextureRect

signal stateChanged

var wire: Wire

#region Event Handlers

# Emits an puzzle event signal when hovering starts
func _on_mouse_entered() -> void:
	CasettePuzzleEvents.hover_input(self)

# Emits an puzzle event signal when hovering stops
func _on_mouse_exited() -> void:
	CasettePuzzleEvents.unhover_input()

# Sets the connedted wire and listens for the wire's state change
func connect_wire(new_wire: Wire):
	wire = new_wire
	wire.stateChanged.connect(_on_changed_state)

# Clears the connected wire and stops listening for the wire's state change
func disconnect_wire():
	wire.stateChanged.disconnect(_on_changed_state)
	wire = null

# Relays a state change signal when the connected wire changes state
func _on_changed_state():
	stateChanged.emit()

#endregion
