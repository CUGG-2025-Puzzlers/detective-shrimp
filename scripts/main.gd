extends Node

# World Roots
@onready var level_root   : Node2D = %LevelRoot
@onready var entity_root  : Node2D = %EntityRoot

# UI Roots
@onready var puzzle_root    : Control = %PuzzleRoot
@onready var hud_root       : Control = %HUDRoot
@onready var transition_root: Control = %TransitionRoot
@onready var pause_root     : Control = %PauseRoot

var player: Player = null

var _current_scene : GameScene   = null
var _current_menu  : Menu        = null
var _current_puzzle: PuzzlePopup = null

func _ready() -> void:
	# Register Event Handlers
	GameEvents.scene_change_requested.connect(_on_scene_change_requested)
	GameEvents.menu_open_requested.connect(_on_menu_open_requested)
	GameEvents.menu_close_requested.connect(_on_menu_close_requested)
	GameEvents.puzzle_open_requested.connect(_on_puzzle_open_requested)
	GameEvents.puzzle_close_requested.connect(_on_puzzle_close_requested)
	
	_load_menu(UID.MAIN_MENU)

#region Event Handlers

## Event Handler for when a scene change is requested.
## Attempts to load the scene given by [param scene_uid]
func _on_scene_change_requested(scene_uid: String, spawn_location_index: int) -> void:
	print("Scene change request accepted. Attempting to load scene %s" % scene_uid)
	_load_scene(scene_uid, spawn_location_index)

## Event Handler for when a menu is requested to be opened.
## Attempts to open the menu given by [param menu_uid]
func _on_menu_open_requested(menu_uid: String) -> void:
	print("Menu open request accepted. Attempting to open menu %s" % menu_uid)
	_load_menu(menu_uid)

## Event Handler for when a menu is requested to be closed.
## Attempts to close the current menu
func _on_menu_close_requested() -> void:
	print("Menu close request accepted. Attempting to close current menu")
	_close_menu()

## Event Handler for when a puzzle is requested to be opened.
## Attempts to open the puzzle given by [param puzzle_uid]
func _on_puzzle_open_requested(puzzle_uid: String) -> void:
	print("Puzzle open request accepted. Attempting to open puzzle %s" % puzzle_uid)
	_load_puzzle(puzzle_uid)

## Event Handler for when a puzzle is requested to be closed.
## Attempts to close the current puzzle
func _on_puzzle_close_requested() -> void:
	print("Puzzle close request accepted. Attempting to close current puzzle")
	_close_puzzle()

#endregion

## Initializes the player
func _init_player() -> void:
	var player_scene: PackedScene = ResourceLoader.load(UID.PLAYER) as PackedScene
	if player_scene == null:
		var error: String = "Could not load player scene: %s" % UID.PLAYER
		push_error(error)
		print(error)
		return
	
	player = player_scene.instantiate() as Player
	if player == null:
		var error: String =\
			"Loaded player scene does not extend Player or does not exist: %s" % UID.PLAYER
		push_error(error)
		print(error)
		return
	
	entity_root.add_child(player)
	player.visible = true

## Spawns the player at the given location if the ID is non-negative. 
## Otherwise despawns the player.
func _try_spawn_player(spawn_location_index: int) -> void:
	if spawn_location_index < 0:
		_despawn_player()
		return
	
	if _current_scene == null:
		var error = "Cannot spawn player: No scene to spawn player into"
		push_error(error)
		print(error)
		return
	
	if player == null:
		_init_player()
		print("Spawned Player")
	
	_current_scene.set_player_location(player, spawn_location_index)

## Despawns the player, removing it from the scene tree
func _despawn_player() -> void:
	if player == null:
		return
	
	player.queue_free()
	player = null
	await get_tree().process_frame
	print("Despawned Player")

## Loads a menu on top of the current scene (if there is one) and pauses the game.
## Only one menu should be loaded at any time (i.e. no stacked menus)
func _load_menu(menu_uid: String) -> void:
	if _current_menu != null:
		var error: String =\
			"Could not load menu %s: Another menu is already open" % menu_uid
		push_error(error)
		print(error)
		return
	
	var menu_scene: PackedScene = ResourceLoader.load(menu_uid) as PackedScene
	if menu_scene == null:
		var error: String = "Could not load menu %s as a packed scene" % menu_uid
		push_error(error)
		print(error)
		return
	
	_current_menu = menu_scene.instantiate() as Menu
	if _current_menu == null:
		var error: String =\
			"Loaded menu %s does not extend Menu or does not exist" % menu_uid
		push_error(error)
		print(error)
		return
	
	get_tree().paused = true
	pause_root.add_child(_current_menu)
	# TODO: Pause or lower level music

## Closes the current menu and returns to control to the current scene
func _close_menu() -> void:
	if _current_menu == null:
		var error: String = "Could not close menu: No menu is currently open"
		push_error(error)
		print(error)
		return
	
	_current_menu.queue_free()
	await get_tree().process_frame
	get_tree().paused = false
	# TODO: Resume or raise level music

## Loads a new game scene in the world, specifically cutscenes and rooms
func _load_scene(scene_uid: String, spawn_location_index: int) -> void:
	_deferred_load_scene.call_deferred(scene_uid, spawn_location_index)

## Does the actual scene loading during idle time
func _deferred_load_scene(scene_uid: String, spawn_location_index: int) -> void:
	# Remove the current scene
	if _current_scene != null:
		_current_scene.queue_free()
		_current_scene = null
		await get_tree().process_frame
	
	# Load the next scene
	var new_scene: PackedScene = ResourceLoader.load(scene_uid) as PackedScene
	if new_scene == null:
		var error: String = "Could not load scene %s as PackedScene" % scene_uid
		push_error(error)
		print(error)
		return
	
	# Instantiate the new scene
	_current_scene = new_scene.instantiate() as GameScene
	if _current_scene == null:
		var error: String =\
			"Loaded scene %s is not of type Scene or does not exist" % scene_uid
		push_error(error)
		print(error)
		return
	
	level_root.add_child(_current_scene)
	await get_tree().process_frame
	
	# TODO: Start level music (if different)
	_try_spawn_player(spawn_location_index)

## Stops the current scene (if there is one) and loads the given puzzle
func _load_puzzle(puzzle_uid: String) -> void:
	# Remove the current scene from the scene tree
	# Do NOT remove it from memory, so it can be added back
	if _current_scene != null:
		# TODO: Stop level music
		level_root.remove_child(_current_scene)
		await get_tree().process_frame
	
	# Load the puzzle popup
	var new_puzzle: PackedScene = ResourceLoader.load(UID.PUZZLE_POPUP) as PackedScene
	if new_puzzle == null:
		var error: String = "Could not load scene %s as PackedScene" % UID.PUZZLE_POPUP
		push_error(error)
		print(error)
		return
	
	# Instantiate the puzzle popup
	var _current_puzzle = new_puzzle.instantiate() as PuzzlePopup
	if _current_puzzle == null:
		var error: String =\
		"Loaded scene %s is not of type PuzzlePopup or does not exist" % UID.PUZZLE_POPUP
		push_error(error)
		print(error)
		return
	
	puzzle_root.add_child(_current_puzzle)
	
	# Load the given puzzle
	var puzzle_scene: PackedScene = ResourceLoader.load(puzzle_uid) as PackedScene
	if puzzle_scene == null:
		var error: String = "Could not load scene %s as PackedScene" % puzzle_uid
		push_error(error)
		print(error)
		return
	
	# Instantiate the given puzzle
	var puzzle = puzzle_scene.instantiate() as Puzzle
	if puzzle == null:
		var error: String =\
		"Loaded scene %s is not of type Puzzle or does not exist" % puzzle_uid
		push_error(error)
		print(error)
		return
	
	_current_puzzle.add_puzzle(puzzle)
	_current_puzzle.center_puzzle()
	await get_tree().process_frame
	# TODO: Start puzzle music
	puzzle.start()

## Closes the current puzzle and returns control to the current scene (if there is one)
func _close_puzzle() -> void:
	if _current_puzzle == null:
		var error: String = "Could not close puzzle: No puzzle is currently open"
		push_error(error)
		print(error)
		return
	
	# Maybe add a fallback scene
	if _current_scene == null:
		var error: String = "Could not return to previous scene. No scene to return to"
		push_error(error)
		print(error)
		return
	
	_current_puzzle.queue_free()
	# TODO: Stop puzzle music
	await get_tree().process_frame
	level_root.add_child(_current_scene)
	# TODO: Start level music
