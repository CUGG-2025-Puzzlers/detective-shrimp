@abstract class_name Puzzle
extends Control

## Returns this puzzle's type
@abstract func get_type() -> GameData.PuzzleType

## Sets up and starts the puzzle
@abstract func start() -> void

## Completes this puzzle
@abstract func finish() -> void
