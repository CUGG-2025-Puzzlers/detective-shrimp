extends NinePatchRect

@export var info: PuzzleInfo

@onready var title: RichTextLabel = $PuzzleTitle
@onready var description: RichTextLabel = $DescriptionText
@onready var objective: RichTextLabel = $ObjectiveText
@onready var restart_button: Button = $RestartButton
@onready var quit_button: Button = $QuitButton

signal puzzle_restarted
signal puzzle_quit

func _ready() -> void:
	if not info:
		print("[Puzzle Instructions] Warning: No info set")
		return
	
	title.text = "[b]%s[/b]" % info.title
	description.text = info.description
	objective.text = info.objective

func _on_restart_pressed() -> void:
	puzzle_restarted.emit()

func _on_quit_pressed() -> void:
	puzzle_quit.emit()
