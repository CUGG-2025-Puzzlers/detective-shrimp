@tool
class_name CassettePuzzle
extends Puzzle

@export var inputs : Array[InputWire]
@export var gates : Array[Control]
@export var outputs : Array[OutputWire]
@export_tool_button("Set Up Inputs") var run_input_setup: Callable = set_up_inputs
@export_tool_button("Set Up Gates") var run_gate_setup: Callable = set_up_gates
@export_tool_button("Set Up Outputs") var run_output_setup: Callable = set_up_outputs

#region Editor Functions

func set_up_inputs():
	inputs.clear()
	
	for child in $%Inputs.get_children():
		if not child is InputWire or not child.visible:
			continue
		
		inputs.append(child)
	
	print("Set up ", inputs.size(), " inputs from children")

func set_up_gates():
	gates.clear()
	
	for child in $%Gates.get_children():
		if not child.visible:
			continue
		
		gates.append(child)
	
	print("Set up ", gates.size(), " gates from children")

func set_up_outputs():
	outputs.clear()
	
	for child in $%Outputs.get_children():
		if not child is OutputWire or not child.visible:
			continue
		
		outputs.append(child)
	
	print("Set up ", outputs.size(), " outputs from children")

#endregion

func start():
	if outputs.size() == 0:
		print("Cannot start Cassette Puzzle, there are no outputs")
		return
	
	for output in outputs:
		output.state_changed.connect(_on_outputs_state_changed)
	
	CassettePuzzleEvents.start_puzzle()

func finish() -> void:
	GameData.cassette_complete = true
	CassettePuzzleEvents.complete_puzzle()

# Checks for completion condition whenever an output is turned on
func _on_outputs_state_changed(new_state: bool) -> void:
	if not new_state:
		return
	
	for output in outputs:
		if not output.state:
			return
	
	GameEvents.finish_puzzle(GameData.PuzzleType.Cassette)
