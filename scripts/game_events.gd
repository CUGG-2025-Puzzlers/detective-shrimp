extends Node

#region Scene Events

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

#region Dialogue Events

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

#region General Puzzle Events

signal puzzle_open_requested(puzzle_uid: String)
signal puzzle_start_requested()
signal puzzle_restart_requested()
signal puzzle_complete_requested()
signal puzzle_close_requested()

signal puzzle_started()
signal puzzle_finished()
signal puzzle_exited()

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

## Emits a signal indicating that the current puzzle has started
func start_puzzle():
	print("Starting current puzzle...")
	puzzle_started.emit()

## Emits a signal indicating that the current puzzle has been completed
func finish_puzzle():
	print("Finishing current puzzle...")
	puzzle_finished.emit()

## Emits a signal indicating that the current puzzle has been exited without completion
func exit_puzzle():
	print("Exiting current puzzle...")
	puzzle_exited.emit()

#endregion

#region Reflection Puzzle Events

signal beam_fired()
signal beam_finished(hit_target: bool)
signal attempted_reflector_placement(reflector: Reflector, pos: Vector2)
signal activated_activator(coords: Vector2i, id: int)

## Emits a signal indicating that the light beam has been fired in the 
## Reflection puzzle
func fire_beam():
	print("Fired light beam!")
	beam_fired.emit()

## Emits a signal indicating that the light beam has finished animating in the 
## Reflection puzzle. Passes along whether or not it hit its target.
func finish_beam(hit_target: bool):
	print("Light beam finished")
	if hit_target:
		print("Hit target!")
	
	beam_finished.emit(hit_target)

## Emits a signal indicating that the given reflector was attempted to be 
## dropped at the given position in the Reflection puzzle
func attempt_reflector_placement(reflector: Reflector, pos: Vector2):
	print("Attempting to place reflector %s at (%d, %d)" % [reflector.name, pos.x, pos.y])
	attempted_reflector_placement.emit(reflector, pos)

## Emits a signal indicating that an activator was activated in the Reflection
## puzzle
func activate_activator(coords: Vector2i, id: int):
	print("Activator %d at (%d, %d) activated!" % [id, coords.x, coords.y])
	activated_activator.emit(coords, id)

#endregion

#region Cryptogram Puzzle Events

signal group_selected(group: CryptogramGroup)
signal bank_letter_clicked(letter: String)
signal letter_enabled(letter: String)
signal letter_disabled(letter: String)

## Emits a signal indicating that the given Cryptogram Group has been selected 
## in the Cryptogram puzzle
func select_group(group: CryptogramGroup) -> void:
	print("Selected group '%s'" % group.expected_letter)
	group_selected.emit(group)

## Emits a signal indicating that the given bank letter was clicked in the 
## Cryptogram puzzle
func click_bank_letter(letter: String):
	print("Clicked on bank letter '%s'" % letter)
	bank_letter_clicked.emit(letter)

## Emits a signal indicating that the given letter has been enabled in the 
## Cryptogram puzzle
func enable_letter(letter: String) -> void:
	print("Enabled letter '%s'" % letter)
	letter_enabled.emit(letter)

## Emits a signal indicating that the given letter has been disabled in the 
## Cryptogram puzzle
func disable_letter(letter: String) -> void:
	print("Disabled letter '%s'" % letter)
	letter_disabled.emit(letter)

#endregion
