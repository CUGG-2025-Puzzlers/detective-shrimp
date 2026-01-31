class_name NotGate
extends Gate

# Evaluates the NOT gate
func evaluate() -> void:
	# Nullifies output if more than 1 input
	if inputs.size() > 1:
		output.change_state(null)
		return
	
	# Nullfies output if input is null
	if has_null_connection():
		output.change_state(null)
		return
	
	# Set output to opposite of input
	output.change_state(!inputs[0].wire.state)
