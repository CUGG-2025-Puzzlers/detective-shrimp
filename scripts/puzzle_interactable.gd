extends Interactable

@export var puzzle_trigger: GameEvents.PuzzleTrigger
@export var post_puzzle_dialogue: Dialogue

func _on_dialogue_ended() -> void:
	if GameEvents.puzzle_already_completed(puzzle_trigger):
		enable()
	else:
		GameEvents.start_puzzle(puzzle_trigger)
		GameEvents.puzzle_finished.connect(_on_puzzle_finished)

func _on_puzzle_finished(trigger: GameEvents.PuzzleTrigger):
	GameEvents.puzzle_finished.disconnect(_on_puzzle_finished)
	dialogue = post_puzzle_dialogue
	enable()
