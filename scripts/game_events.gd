extends Node


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
