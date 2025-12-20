class_name AndGate
extends Gate

# Evaluates the AND gate
func evaluate() -> void:
	# Nullifies output if any null inputs
	if has_null_connection():
		output.change_state(null)
		return
	
	# Checks for any off connections
	for input in inputs:
		if not input.wire.state:
			output.change_state(false)
			return
	
	# No off connections, set output to on
	output.change_state(true)
