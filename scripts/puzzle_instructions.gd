class_name PuzzleIntructions
extends NinePatchRect

@export var info: PuzzleInfo

@onready var _title      : RichTextLabel = $PuzzleTitle
@onready var _description: RichTextLabel = $DescriptionText
@onready var _objective  : RichTextLabel = $ObjectiveText

@onready var _restart_button: Button = $RestartButton
@onready var _quit_button   : Button = $QuitButton

func _ready() -> void:
	_restart_button.pressed.connect(_on_restart_pressed)
	_quit_button.pressed.connect(_on_quit_pressed)
	GameEvents.puzzle_complete_requested.connect(_on_puzzle_complete_requested)
	
	if not info:
		print("[Puzzle Instructions] Warning: No info set")
		return
	
	_title.text = "[b]%s[/b]" % info.title
	_description.text = info.description
	_objective.text = info.objective
	_restart_button.disabled = false

## Event Handler for when the Restart button is pressed.
## Requests that the puzzle be restarted
func _on_restart_pressed() -> void:
	GameEvents.request_puzzle_restart()

## Event Handler for when the Quit button is pressed.
## Requests that the puzzle be quit
func _on_quit_pressed() -> void:
	GameEvents.request_puzzle_close()

## Event Handler for when the current puzzle has been completed
## Disables the restart button
func _on_puzzle_complete_requested() -> void:
	_restart_button.disabled = true
