class_name GameData

# Puzzle completion tracker
static var puzzle_completion_status: int = 0

# Interact flag
static var grocery_list: bool = false
static var napped      : bool = false

## Loads previous game data from the save file
static func load_game_data() -> void:
	pass

## Saves game data onto a save file
static func save_game_data() -> void:
	pass

## Sets the given puzzle's completion flag to true
static func complete_puzzle(puzzle_type: PuzzleType) -> void:
	puzzle_completion_status |= puzzle_type

## Returns true if the given puzzle has been completed
static func puzzle_already_completed(puzzle_type: PuzzleType) -> bool:
	return (puzzle_completion_status & puzzle_type) != 0

## Puzzle Types
enum PuzzleType {
	None     = 0,
	Key      = 1 << 1,
	Cassette = 1 << 2,
	Light    = 1 << 3,
	Letter   = 1 << 4,
	Safe     = 1 << 5,
}
