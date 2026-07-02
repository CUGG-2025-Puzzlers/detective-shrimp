extends Interactable

@export var id    : int
@export var locked: bool

@export var exit_scene         : GameScene.SceneType
@export var exit_location_index: int

func _ready() -> void:
	GameEvents.door_unlock_requested.connect(_on_door_unlock_requested)

## Event Handler for when a door unlock has been requested
## Unlocks this door if the requested ID matches this door's ID
func _on_door_unlock_requested(door_id: int) -> void:
	if door_id != id:
		return
	
	_unlock()

## Unlocks this door
func _unlock():
	locked = false

## If locked, displays lock dialogue. Otherwise transitions to the connected scene.
func interaction() -> void:
	if locked:
		super.interaction()
		return
	
	GameEvents.request_scene_change(UID.GAME_SCENES[exit_scene], exit_location_index)
