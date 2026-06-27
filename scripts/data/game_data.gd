class_name GameData

# Puzzle completion flags
static var mailbox_complete   : bool = false
static var reflection_complete: bool = false
static var cassette_complete  : bool = false
static var letter_complete    : bool = false
static var safe_complete      : bool = false

# Interact flag
static var grocery_list: bool = false
static var napped      : bool = false

## Loads previous game data from the save file
static func load_game_data() -> void:
	pass

## Saves game data onto a save file
static func save_game_data() -> void:
	pass

## Returns true if a puzzle has been completed
static func puzzle_already_completed(puzzle: PuzzleType) -> bool:
	match puzzle:
		PuzzleType.Key:
			return mailbox_complete
		PuzzleType.Cassette:
			return cassette_complete
		PuzzleType.Light:
			return reflection_complete
		PuzzleType.Letter:
			return letter_complete
		PuzzleType.Safe:
			return safe_complete

	return false

## Puzzle Types
enum PuzzleType {
	None,
	Key,
	Cassette,
	Light,
	Letter,
	Safe,
}
