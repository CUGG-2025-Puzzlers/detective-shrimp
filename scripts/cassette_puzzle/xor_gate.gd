class_name XorGate
extends Gate

# Evaluates the XNOR gate
func evaluate() -> void:
	# Nullifies output if any null inputs
	if has_null_connection():
		output.change_state(null)
		return
	
	# Counts on connections
	var on_count = 0
	for input in inputs:
		if input.wire.state:
			on_count += 1
	
	# Set output to on if count was odd
	output.change_state(on_count % 2 == 1)
