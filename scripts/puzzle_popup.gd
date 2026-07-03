class_name PuzzlePopup
extends Control

@export var _puzzle     : Puzzle
@export var _puzzle_type: GameData.PuzzleType

var previous_music: AudioManager.MusicTheme

func _ready() -> void:
	close()
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
