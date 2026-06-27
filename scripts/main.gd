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

var _current_scene: Scene = null
var _current_menu : Menu = null

func _ready() -> void:
	# Register Event Handlers
	GameEvents.scene_change_requested.connect(_on_scene_change_requested)
	GameEvents.menu_open_requested.connect(_on_menu_open_requested)
	GameEvents.menu_close_requested.connect(_on_menu_close_requested)
	
	_load_menu(UID.MAIN_MENU)

#region Event Handlers

## Event Handler for when a scene change is requested.
## Attempts to load the scene given by [param scene_uid]
func _on_scene_change_requested(scene_uid: String) -> void:
	print("Scene change request accepted. Attempting to load scene %s" % scene_uid)
	_load_scene(scene_uid)

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

## Loads a new game scene in the world, specifically cutscenes and rooms
func _load_scene(scene_uid: String) -> void:
	_deferred_load_scene.call_deferred(scene_uid)

## Does the actual scene loading during idle time
func _deferred_load_scene(scene_uid: String) -> void:
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
	_current_scene = new_scene.instantiate() as Scene
	if _current_scene == null:
		var error: String =\
			"Loaded scene %s is not of type Scene or does not exist" % scene_uid
		push_error(error)
		print(error)
		return
	
	level_root.add_child(_current_scene)
	await get_tree().process_frame

## Stops the current scene (if there is one) and loads a puzzle
func _load_puzzle() -> void:
	pass
