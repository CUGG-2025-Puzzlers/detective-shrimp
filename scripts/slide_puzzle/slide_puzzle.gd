class_name SlidePuzzle
extends Puzzle

@onready var board: SlidePuzzleBoard = $%Board

func get_type() -> GameData.PuzzleType:
	return GameData.PuzzleType.Key

# Starts the puzzle and notifies all pieces
func start() -> void:
	print("Starting Key Puzzle")
	GameEvents.start_puzzle(get_type())
	board.print_board()
	for piece in board.pieces:
		piece._on_puzzle_started()

# Completes this board
func finish() -> void:
	print("Key Puzzle Completed!")
