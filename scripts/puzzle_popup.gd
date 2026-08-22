class_name PuzzlePopup
extends Control

@export var _puzzle: Puzzle

@onready var _puzzle_containter: Control = %PuzzleContainer

## Adds the given puzzle to the popup as a child of the container
func add_puzzle(puzzle: Puzzle) -> void:
	_puzzle = puzzle
	_puzzle_containter.add_child(puzzle)

## Centers the puzzle within the puzzle area based on its set size
func center_puzzle() -> void:
	if _puzzle == null:
		var error: String = "Cannot center puzzle: No puzzle found"
		push_error(error)
		print(error)
		return
	
	_puzzle.position = (_puzzle_containter.size - _puzzle.size) / 2
