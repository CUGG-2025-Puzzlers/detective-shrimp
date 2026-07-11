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

#region Puzzle Events

signal puzzle_open_requested(puzzle_uid: String)
signal puzzle_start_requested()
signal puzzle_restart_requested()
signal puzzle_complete_requested()
signal puzzle_close_requested()

signal puzzle_started()
signal puzzle_finished()
signal puzzle_exited()

signal beam_fired()
signal beam_finished(hit_target: bool)
signal attempted_reflector_placement(reflector: Reflector, pos: Vector2)
signal activated_activator(coords: Vector2i, id: int)

## Emits a signal indicating that a given puzzle was requested to be opened
func request_puzzle_open(puzzle_uid: String) -> void:
	print("Requesting to open puzzle %s" % puzzle_uid)
	puzzle_open_requested.emit(puzzle_uid)

## Emits a signal indicating that the current puzzle was requested to be started
func request_puzzle_start() -> void:
	print("Requesting to start current puzzle")
	puzzle_start_requested.emit()

## Emits a signal indicating that the current puzzle was requested to be restarted
func request_puzzle_restart() -> void:
	print("Requesting to restart current puzzle")
	puzzle_restart_requested.emit()

## Emits a signal indicating that the current puzzle was requested to be completed
func request_puzzle_complete() -> void:
	print("Requesting to complete current puzzle")
	puzzle_complete_requested.emit()

## Emits a signal indicating that the current puzzle was requested to be closed
func request_puzzle_close() -> void:
	print("Requesting to close current puzzle")
	puzzle_close_requested.emit()

func start_puzzle():
	print("Starting current puzzle...")
	puzzle_started.emit()

func finish_puzzle():
	print("Finishing current puzzle...")
	puzzle_finished.emit()

func exit_puzzle():
	print("Exiting current puzzle...")
	puzzle_exited.emit()

func fire_beam():
	print("Fired light beam!")
	beam_fired.emit()

func finish_beam(hit_target: bool):
	print("Light beam finished")
	if hit_target:
		print("Hit target!")
	
	beam_finished.emit(hit_target)

func attempt_reflector_placement(reflector: Reflector, pos: Vector2):
	print("Attempting to place reflector %s at (%d, %d)" % [reflector.name, pos.x, pos.y])
	attempted_reflector_placement.emit(reflector, pos)

func activate_activator(coords: Vector2i, id: int):
	print("Activator %d at (%d, %d) activated!" % [id, coords.x, coords.y])
	activated_activator.emit(coords, id)

#endregion
