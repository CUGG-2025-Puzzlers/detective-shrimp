class_name SplitterGate
extends Gate

@export var outputs: Array[Wire]

# Evaluates the Splitter gate
func evaluate() -> void:
	# Nullifies output if more than 1 input
	if inputs.size() > 1:
		output.change_state(null)
		return
	
	# Nullfies output if input is null
	if has_null_connection():
		output.change_state(null)
		return
	
	# Set outputs to same as input
	var state = inputs[0].wire.state
	output.change_state(state)
	for wire in outputs:
		wire.change_state(state)
