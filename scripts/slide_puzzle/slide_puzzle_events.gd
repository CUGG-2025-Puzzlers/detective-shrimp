extends Node

signal puzzle_started()
signal puzzle_completed()

func start_puzzle() -> void:
	puzzle_started.emit()

func complete_puzzle() -> void:
	puzzle_completed.emit()
