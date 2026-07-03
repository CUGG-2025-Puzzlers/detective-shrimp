class_name UID

const TRANSISTION: String = "uid://bopaumfmgwclf"

# Menu UIDs
const MAIN_MENU  : String = "uid://dkrxhuquv6u7e"
const PAUSE_MENU : String = "uid://cm6m3sqg1eibe"
const END_CREDITS: String = "uid://cgg8lih65lgox"

# Cutscene UIDs
const CAR_CUTSCENE: String = "uid://7ivr7mc4jp21"
const END_CUTSCENE: String = "uid://jmd287xjo7bm"

# Room UIDs
const OUTSIDE    : String = "uid://xbadgawwhojf"
const KITCHEN    : String = "uid://stupsk6vmjcq"
const LIVING_ROOM: String = "uid://7jgwmr3e8qj8"
const HALLWAY    : String = "uid://ckoouorrcli7d"
const BEDROOM    : String = "uid://e40t17p2oxny"

# Puzzle UIDs
const PUZZLE_POPUP   : String = "uid://wglw4rfn1fc1"
const KEY_PUZZLE     : String = "uid://dc4tvs8q0i3hb"
const LIGHT_PUZZLE   : String = "uid://mcdlnsiojpgm"
const CASSETTE_PUZZLE: String = "uid://ch13qt1fo7jef"
const LETTER_PUZZLE  : String = "uid://n4wqsj43w5yj"
const SAFE_PUZZLE    : String = "uid://hishica6nnlj"

# Entity UIDs
const PLAYER: String = "uid://dknb10beku6mq"

# GameScene -> UID map
const GAME_SCENES: Dictionary[GameScene.SceneType, String] = {
	GameScene.SceneType.CarCutscene      : CAR_CUTSCENE,
	GameScene.SceneType.Yard             : OUTSIDE,
	GameScene.SceneType.Kitchen          : KITCHEN,
	GameScene.SceneType.LivingRoom       : LIVING_ROOM,
	GameScene.SceneType.Hallway          : HALLWAY,
	GameScene.SceneType.Bedroom          : BEDROOM,
	GameScene.SceneType.BasementCutscene : END_CUTSCENE
}

# PuzzleType -> UID map
const PUZZLES: Dictionary[GameData.PuzzleType, String] = {
	GameData.PuzzleType.Key     : KEY_PUZZLE,
	GameData.PuzzleType.Cassette: CASSETTE_PUZZLE,
	GameData.PuzzleType.Light   : LIGHT_PUZZLE,
	GameData.PuzzleType.Letter  : LETTER_PUZZLE,
	GameData.PuzzleType.Safe    : SAFE_PUZZLE
}
