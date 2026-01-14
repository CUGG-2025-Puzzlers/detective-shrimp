extends Node

signal puzzle_started()
signal puzzle_completed()
signal piece_moved()

func start_puzzle() -> void:
	puzzle_started.emit()

func complete_puzzle() -> void:
	puzzle_completed.emit()

func move_piece() -> void:
	piece_moved.emit()
