class_name OutputWire
extends Node

signal state_changed(new_state: bool)
var state: bool = false

# Listen for underlying Gate Input state changes
func _ready() -> void:
	$%WireConnection.state_changed.connect(_on_state_changed)

# Emit a signal whenever the state is toggled between true or false values
# Null is treated as false
func _on_state_changed():
	var new_state: bool
	if $%WireConnection.wire == null:
		new_state = false
	else:
		new_state = (bool)($%WireConnection.wire.state)
	
	if new_state == state:
		return
	
	state = new_state
	state_changed.emit(state)
