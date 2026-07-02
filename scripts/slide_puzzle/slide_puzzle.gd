class_name SlidePuzzle
extends Puzzle

@onready var board: SlidePuzzleBoard = $%Board

# Starts the puzzle and notifies all pieces
func start() -> void:
	SlidePuzzleEvents.start_puzzle()
	board.print_board()
	for piece in board.pieces:
		piece._on_puzzle_started()

# Completes this board
func finish() -> void:
	print("You win!")
	SlidePuzzleEvents.complete_puzzle()
