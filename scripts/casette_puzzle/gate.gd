@abstract class_name Gate
extends TextureRect

@export var inputs: Array[GateInput]
@export var output: Wire

@abstract func evaluate() -> void

func _ready() -> void:
	# Listens for input changes from all inputs for this gate
	for input in inputs:
		input.stateChanged.connect(_on_input_state_changed)

#region Event Handlers

# Reevaluates the state of this gate whenever one of the inputs changes state
func _on_input_state_changed() -> void:
	evaluate()

#endregion
