extends Interactable

@export var locked: bool
@export var flag_check: String
@export var exit_scene: PackedScene

func _ready() -> void:
	if flag_check == "" or not GameEvents.get(flag_check):
		return
	
	unlock()

func unlock():
	locked = false

func interaction() -> void:
	if locked:
		if not GameEvents.get(flag_check):
			super.interaction()
			return
		
		unlock()
	
	Globals.transition_to_scene(exit_scene)
