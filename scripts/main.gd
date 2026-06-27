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

var _current_menu : Menu = null

func _ready() -> void:
	load_menu(UID.MAIN_MENU)

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
func load_menu(menu_uid: String) -> void:
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
func close_menu() -> void:
	if _current_menu == null:
		var error: String = "Could not close menu: No menu is currently open"
		push_error(error)
		print(error)
		return
	
	_current_menu.queue_free()
	await get_tree().process_frame
	get_tree().paused = false

## Loads a new game scene in the world, specifically cutscenes and rooms
func load_scene(scene_uid: String) -> void:
	_deferred_load_scene.call_deferred(scene_uid)

## Does the actual scene loading during idle time
func _deferred_load_scene(scene_uid: String) -> void:
	pass

## Stops the current scene (if there is one) and loads a puzzle
func load_puzzle() -> void:
	pass
