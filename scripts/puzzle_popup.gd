extends Control

@export var puzzle: Puzzle
@export var puzzle_trigger: GameEvents.PuzzleTrigger

var previous_music: AudioStream

func _ready() -> void:
	close()
	GameEvents.puzzle_started.connect(_on_puzzle_started)
	GameEvents.puzzle_finished.connect(_on_puzzle_finished)

func _on_puzzle_started(trigger: GameEvents.PuzzleTrigger):
	if trigger != puzzle_trigger:
		return
	
	open()
	puzzle.start()
	previous_music = AudioManager.get_current_music()
	AudioManager.play_background_music(AudioManager.puzzle_theme)

func _on_puzzle_finished(trigger: GameEvents.PuzzleTrigger):
	if trigger != puzzle_trigger:
		return
	
	AudioManager.play_background_music(previous_music)
	puzzle.finish()
	close()

func open():
	visible = true

func close():
	visible = false
