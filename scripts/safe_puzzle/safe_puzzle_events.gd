extends Node

signal puzzle_started()
signal puzzle_completed()

func start_puzzle() -> void:
	print("Started Safe Puzzle")
	puzzle_started.emit()

func complete_puzzle() -> void:
	print("Completed Safe Puzzle")
	GameEvents.safe = true
	puzzle_completed.emit()
