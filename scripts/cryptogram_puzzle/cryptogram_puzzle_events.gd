extends Node

signal puzzle_started()
signal puzzle_completed()

func start_puzzle() -> void:
	print("Started Cryptogram Puzzle")
	puzzle_started.emit()

func complete_puzzle() -> void:
	print("Completed Cryptogram Puzzle")
	puzzle_completed.emit()
