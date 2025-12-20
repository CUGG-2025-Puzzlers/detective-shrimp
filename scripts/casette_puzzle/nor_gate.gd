class_name NorGate
extends Gate

# Evaluates the NOR gate
func evaluate() -> void:
	# Nullifies output if any null inputs
	if has_null_connection():
		output.change_state(null)
		return
	
	# Checks for any on connections
	for input in inputs:
		if input.wire.state:
			output.change_state(false)
			return
	
	# No on connections, set output to on
	output.change_state(true)
