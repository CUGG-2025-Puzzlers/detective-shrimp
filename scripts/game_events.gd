extends Node

#region Flags

#Puzzle completion flags
var mailbox_complete = false
var reflection_complete = false
var casette_complete = false
var letter_complete = false

#Interact flag
var grocery_list = false

#endregion

#region Dialogue

signal dialogue_started(dialogue: Dialogue)
signal dialogue_line_ended(cur_line: int)
signal dialogue_ended()

func start_dialogue(dialogue: Dialogue):
	dialogue_started.emit(dialogue)

func end_dialogue_line(cur_line: int):
	dialogue_line_ended.emit(cur_line)

func end_dialogue():
	dialogue_ended.emit()

#endregion

#region Puzzle Events

signal puzzle_started(trigger: PuzzleTrigger)
signal puzzle_finished()

func start_puzzle(trigger: PuzzleTrigger):
	puzzle_started.emit(trigger)

func finish_puzzle():
	puzzle_finished.emit()

enum PuzzleTrigger {
	None,
	PuzzleSlide,
	PuzzleCassette,
	PuzzleLight,
	PuzzleDecryption,
}

#endregion
