@abstract class_name Gate
extends TextureRect

var inputs: Array[GateInput]
var output: Wire

@abstract func evaluate() -> void

func _ready() -> void:
	# Sets up input(s) and output
	for child in get_children():
		if not child.visible:
			continue
		
		if child is GateInput:
			inputs.append(child)
			child.state_changed.connect(_on_input_state_changed)
			continue
		
		if child is Wire:
			output = child

#region Event Handlers

# Reevaluates the state of this gate whenever one of the inputs changes state
func _on_input_state_changed() -> void:
	evaluate()

#endregion

# Checks for any null connections
func has_null_connection() -> bool:
	for input in inputs:
		if input.wire == null or input.wire.state == null:
			return true
	
	return false
