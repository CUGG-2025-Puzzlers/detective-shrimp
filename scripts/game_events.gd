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

func trigger_event(event: EventTrigger):
	match event:
		EventTrigger.PuzzleSlide:
			SlidePuzzleEvents.start_puzzle()
		EventTrigger.PuzzleCassette:
			CassettePuzzleEvents.start_puzzle()

enum EventTrigger {
	None,
	PuzzleSlide,
	PuzzleCassette,
	PuzzleLight,
	PuzzleDecryption,
}

#endregion
