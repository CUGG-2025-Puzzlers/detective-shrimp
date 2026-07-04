class_name PuzzlePopup
extends Control

@export var _puzzle     : Puzzle
@export var _puzzle_type: GameData.PuzzleType

@onready var _puzzle_containter: Control = %PuzzleContainer

var previous_music: AudioManager.MusicTheme

func _ready() -> void:
	GameEvents.puzzle_started.connect(_on_puzzle_started)
	GameEvents.puzzle_finished.connect(_on_puzzle_finished)

func _on_puzzle_started(puzzle: GameData.PuzzleType):
	if puzzle != _puzzle_type:
		return
	
	open()
	_puzzle.start()

func _on_puzzle_finished(puzzle: GameData.PuzzleType):
	if puzzle != _puzzle_type:
		return
	
	_puzzle.finish()
	close()

func open():
	visible = true
	previous_music = AudioManager.current_theme
	AudioManager.play_background_music(AudioManager.MusicTheme.Puzzle)

func close():
	visible = false
	AudioManager.play_background_music(previous_music)

func _on_exit_pressed():
	close()
	GameEvents.exit_puzzle(_puzzle_type)

## Adds the given puzzle to the popup as a child of the container
func add_puzzle(puzzle: Puzzle) -> void:
	_puzzle = puzzle
	_puzzle_containter.add_child(puzzle)

func center_puzzle() -> void:
	if _puzzle == null:
		var error: String = "Cannot center puzzle: No puzzle found"
		push_error(error)
		print(error)
		return
	
	_puzzle.position = (_puzzle_containter.size - _puzzle.size) / 2
