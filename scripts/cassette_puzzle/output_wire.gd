extends Node

signal state_changed(new_state: bool)
var state: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$%WireConnection.state_changed.connect()

func _on_state_changed():
	var new_state: bool
	if $%WireConnection.wire == null:
		new_state = false
	else:
		new_state = (bool)($%WireConnection.wire.state)
	
	if new_state == state:
		return
	
	state_changed.emit(state)
