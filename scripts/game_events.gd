extends Node

#region Flags

#Puzzle completion flags
var mailbox_complete: bool = false
var reflection_complete: bool = false
var cassette_complete: bool = false
var letter_complete: bool = false

#Interact flag
var grocery_list: bool = false
var safe: bool = false
var napped: bool = false

#endregion

#region Dialogue

signal dialogue_started(dialogue: Dialogue)
signal dialogue_line_ended(cur_line: int)
signal dialogue_ended(name: String)

func start_dialogue(dialogue: Dialogue):
	dialogue_started.emit(dialogue)

func end_dialogue_line(cur_line: int):
	dialogue_line_ended.emit(cur_line)

func end_dialogue(name: String):
	dialogue_ended.emit(name)

#endregion

#region Scene Events

signal scene_changed(scene_name: String)

func change_scene(scene_name: String):
	scene_changed.emit(scene_name)

#endregion

#region Puzzle Events

signal puzzle_started(trigger: PuzzleTrigger)
signal puzzle_finished(trigger: PuzzleTrigger)

func start_puzzle(trigger: PuzzleTrigger):
	if puzzle_already_completed(trigger):
		return
	
	print("Starting Puzzle...")
	puzzle_started.emit(trigger)
	Globals.hide_player()

func finish_puzzle(trigger: PuzzleTrigger):
	if puzzle_already_completed(trigger):
		return
	
	print("Finishing Puzzle...")
	puzzle_finished.emit(trigger)
	Globals.show_player()

func puzzle_already_completed(trigger: PuzzleTrigger) -> bool:
	match trigger:
		PuzzleTrigger.PuzzleSlide:
			return mailbox_complete
		PuzzleTrigger.PuzzleCassette:
			return cassette_complete
		PuzzleTrigger.PuzzleLight:
			return reflection_complete
		PuzzleTrigger.PuzzleDecryption:
			return letter_complete
		PuzzleTrigger.PuzzleSafe:
			return safe

	return false

enum PuzzleTrigger {
	None,
	PuzzleSlide,
	PuzzleCassette,
	PuzzleLight,
	PuzzleDecryption,
	PuzzleSafe,
}

#endregion
