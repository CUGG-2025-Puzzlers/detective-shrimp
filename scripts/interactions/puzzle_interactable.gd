extends Interactable

@export var puzzle_type: GameData.PuzzleType
@export var post_puzzle_dialogue: Dialogue

func _on_dialogue_ended(name: String) -> void:
	if not interacting or GameData.puzzle_already_completed(puzzle_type):
		enable()
		return
	
	GameEvents.request_puzzle_open(UID.PUZZLES[puzzle_type])
	GameEvents.puzzle_finished.connect(_on_puzzle_finished)
	GameEvents.puzzle_exited.connect(_on_puzzle_exited)

func _on_puzzle_finished(puzzle: GameData.PuzzleType):
	GameEvents.puzzle_finished.disconnect(_on_puzzle_finished)
	dialogue = post_puzzle_dialogue
	enable()

func _on_puzzle_exited(puzzle: GameData.PuzzleType):
	GameEvents.puzzle_finished.disconnect(_on_puzzle_finished)
	enable()
