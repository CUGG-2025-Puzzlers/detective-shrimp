extends Control

@export var puzzle: Puzzle
@export var puzzle_trigger: GameEvents.PuzzleTrigger

var previous_music: AudioManager.MusicTheme

func _ready() -> void:
	close()
	GameEvents.puzzle_started.connect(_on_puzzle_started)
	GameEvents.puzzle_finished.connect(_on_puzzle_finished)

func _on_puzzle_started(trigger: GameEvents.PuzzleTrigger):
	if trigger != puzzle_trigger:
		return
	
	open()
	puzzle.start()

func _on_puzzle_finished(trigger: GameEvents.PuzzleTrigger):
	if trigger != puzzle_trigger:
		return
	
	puzzle.finish()
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
	GameEvents.exit_puzzle(puzzle_trigger)
