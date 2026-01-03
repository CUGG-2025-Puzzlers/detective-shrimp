class_name OrGate
extends Gate

# Evaluates the OR gate
func evaluate() -> void:
	# Nullifies output if any null inputs
	if has_null_connection():
		output.change_state(null)
		return
	
	# Checks for any on connection
	for input in inputs:
		if input.wire.state:
			output.change_state(true)
			return
	
	# No on connection, set output to off
	output.change_state(false)
