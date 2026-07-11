extends Interactable

@export var puzzle_type: GameData.PuzzleType
@export var post_puzzle_dialogue: Dialogue

func _on_dialogue_ended(name: String) -> void:
	enable()
	
	if name != dialogue.name:
		return
	
	if GameData.puzzle_already_completed(puzzle_type):
		return
	
	GameEvents.request_puzzle_open(UID.PUZZLES[puzzle_type])

func interaction():
	if GameData.puzzle_already_completed(puzzle_type):
		GameEvents.start_dialogue(post_puzzle_dialogue)
	else:
		GameEvents.start_dialogue(dialogue)
