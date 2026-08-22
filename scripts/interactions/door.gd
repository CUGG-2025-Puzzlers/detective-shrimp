extends Interactable

@export var puzzle_lock: GameData.PuzzleType
@export var locked     : bool

@export var exit_scene         : GameScene.SceneType
@export var exit_location_index: int

## Unlocks this door
func _unlock():
	locked = false

## If locked, displays lock dialogue. Otherwise transitions to the connected scene.
func interaction() -> void:
	if locked and puzzle_lock != GameData.PuzzleType.None:
		locked = not GameData.puzzle_already_completed(puzzle_lock)
	
	if not locked:
		GameEvents.request_scene_change(UID.GAME_SCENES[exit_scene], exit_location_index)
		return
	
	super.interaction()
