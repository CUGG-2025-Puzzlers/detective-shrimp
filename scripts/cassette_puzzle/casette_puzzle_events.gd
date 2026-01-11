extends Node

signal puzzle_started()
signal puzzle_completed()
signal hovered_input(input: GateInput)
signal unhovered_input()

func start_puzzle() -> void:
	puzzle_started.emit()
	print("Started Cassette Puzzle")

func complete_puzzle() -> void:
	puzzle_completed.emit()
	print("Completed Cassette Puzzle")

func hover_input(input: GateInput) -> void:
	hovered_input.emit(input)

func unhover_input() -> void:
	unhovered_input.emit()
