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
signal puzzle_exited(trigger: PuzzleTrigger)

signal beam_fired()
signal attempted_reflector_placement(reflector: Reflector, pos: Vector2)
signal activated_activator(coords: Vector2i, id: int)
signal target_hit()

func start_puzzle(trigger: PuzzleTrigger):
	if puzzle_already_completed(trigger):
		return
	
	print("Starting Puzzle...")
	puzzle_started.emit(trigger)

func finish_puzzle(trigger: PuzzleTrigger):
	if puzzle_already_completed(trigger):
		return
	
	print("Finishing Puzzle...")
	puzzle_finished.emit(trigger)

func exit_puzzle(trigger: PuzzleTrigger):
	if puzzle_already_completed(trigger):
		return
	
	print("Exiting Puzzle...")
	puzzle_exited.emit(trigger)

func fire_beam():
	print("Fired light beam!")
	beam_fired.emit()

func attempt_reflector_placement(reflector: Reflector, pos: Vector2):
	print("Attempting to place reflector %s at (%d, %d)" % [reflector.name, pos.x, pos.y])
	attempted_reflector_placement.emit(reflector, pos)

func activate_activator(coords: Vector2i, id: int):
	print("Activator %d at (%d, %d) activated!" % [id, coords.x, coords.y])
	activated_activator.emit(coords, id)

func hit_target():
	print("Target Hit!")
	target_hit.emit()

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
