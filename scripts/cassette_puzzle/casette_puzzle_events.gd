extends Node

signal hovered_input(input: GateInput)
signal unhovered_input()

func hover_input(input: GateInput) -> void:
	hovered_input.emit(input)

func unhover_input() -> void:
	unhovered_input.emit()
