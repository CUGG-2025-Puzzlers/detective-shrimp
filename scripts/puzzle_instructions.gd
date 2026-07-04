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
	
	if not info:
		print("[Puzzle Instructions] Warning: No info set")
		return
	
	_title.text = "[b]%s[/b]" % info.title
	_description.text = info.description
	_objective.text = info.objective

## Event Handler for when the Restart button is pressed.
## Requests that the puzzle be restarted
func _on_restart_pressed() -> void:
	GameEvents.request_puzzle_restart()

## Event Handler for when the Quit button is pressed.
## Requests that the puzzle be quit
func _on_quit_pressed() -> void:
	GameEvents.request_puzzle_close()
