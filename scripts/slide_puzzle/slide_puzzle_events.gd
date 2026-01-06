extends Node

signal puzzle_started()
signal puzzle_completed()

func start_puzzle() -> void:
	print("Started Slide Puzzle")
	puzzle_started.emit()

func complete_puzzle() -> void:
	print("Completed Slide Puzzle")
	puzzle_completed.emit()
