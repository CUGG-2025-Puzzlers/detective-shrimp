extends Gate

func evaluate() -> void:
	for input in inputs:
		if not input.wire.state:
			output.change_state(false)
			return
	
	output.change_state(true)
