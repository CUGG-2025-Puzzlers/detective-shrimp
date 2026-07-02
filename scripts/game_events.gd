extends Node

#region Scenes

signal scene_change_requested(scene_uid: String, spawn_location_index: int)
signal menu_open_requested(menu_uid: String)
signal menu_close_requested()

## Emits a signal that a scene change was requested.
func request_scene_change(scene_uid: String, spawn_location_index: int) -> void:
	print("Requesting scene change to %s" % scene_uid)
	scene_change_requested.emit(scene_uid, spawn_location_index)

## Emits a signal that a menu was requested to be opened.
func request_menu_open(menu_uid: String) -> void:
	print("Requesting to open menu %s" % menu_uid)
	menu_open_requested.emit(menu_uid)

## Emits a signal that a menu was requested to be closed.
func request_menu_close() -> void:
	print("Requesting to close current menu")
	menu_close_requested.emit()

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

signal door_unlock_requested(door_id: int)

## Emits a signal that doors were requested to be unlocked
func request_door_unlock(door_id: int) -> void:
	print("Requesting to unlock all doors with ID %d" % door_id)
	door_unlock_requested.emit(door_id)

#endregion

#region Puzzle Events

signal puzzle_started(puzzle: GameData.PuzzleType)
signal puzzle_finished(puzzle: GameData.PuzzleType)
signal puzzle_exited(puzzle: GameData.PuzzleType)

func start_puzzle(puzzle: GameData.PuzzleType):
	if GameData.puzzle_already_completed(puzzle):
		return
	
	print("Starting Puzzle...")
	puzzle_started.emit(puzzle)

func finish_puzzle(puzzle: GameData.PuzzleType):
	if GameData.puzzle_already_completed(puzzle):
		return
	
	print("Finishing Puzzle...")
	puzzle_finished.emit(puzzle)

func exit_puzzle(puzzle: GameData.PuzzleType):
	if GameData.puzzle_already_completed(puzzle):
		return
	
	print("Exiting Puzzle...")
	puzzle_exited.emit(puzzle)

#endregion
