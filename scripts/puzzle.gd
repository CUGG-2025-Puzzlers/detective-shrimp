@abstract class_name Puzzle
extends Control

## Returns this puzzle's type
@abstract func get_type() -> GameData.PuzzleType

## Sets up and starts the puzzle
@abstract func start() -> void

## Completes this puzzle
@abstract func finish() -> void

func _ready() -> void:
	GameEvents.puzzle_start_requested.connect(_on_puzzle_start_requested)
	GameEvents.puzzle_complete_requested.connect(_on_puzzle_complete_requested)

func _on_puzzle_start_requested() -> void:
	print("Puzzle start request accepted. Attempting to start puzzle %d" % get_type())
	start()
	GameEvents.start_puzzle()

func _on_puzzle_complete_requested() -> void:
	print("Puzzle complete requested accepted. Attempting to complete puzzle %d" % get_type())
	finish()
	GameData.complete_puzzle(get_type())
	GameEvents.finish_puzzle()
