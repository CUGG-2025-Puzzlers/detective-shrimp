class_name Interactable
extends TextureRect

@export var interaction_range: int
@export var dialogue: Dialogue

var enabled = true
var interactable = false
var interacting = false

var basement_dialogue: Dialogue

func _ready() -> void:
	mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN
	GameEvents.dialogue_started.connect(_on_dialogue_started)
	GameEvents.dialogue_ended.connect(_on_dialogue_ended)
	
	basement_dialogue = preload("res://resources/dialogue/interact/living_room/basement_door.tres")

func _process(delta: float) -> void:
	if not interactable and is_player_in_range():
		interactable = true
		mouse_default_cursor_shape = Control.CURSOR_HELP
		return
	
	if interactable and not is_player_in_range():
		interactable = false
		mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN
		return

#region Event Handlers

func _gui_input(event: InputEvent) -> void:
	# Checking for Mouse Button Left events
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			_on_mouse_down()

func _on_mouse_down() -> void:
	interact()

func _on_dialogue_started(dialogue: Dialogue) -> void:
	disable()

func _on_dialogue_ended() -> void:
	enable()

#endregion

func interact() -> void:
	if not enabled or not interactable:
		return
	
	interacting = true
	
	# Special interaction when Basement door is interacted with after 
	# the key is obtained from the safe.
	# Definitely not the best way to implement it, but I don't know 
	# how else to do it. - Cameron
	if name == "Basement Door" and GameEvents.safe == true:
		GameEvents.start_dialogue(basement_dialogue)
		GameEvents.dialogue_ended.connect(_on_enter_basement)
		return

	GameEvents.start_dialogue(dialogue)

func _on_enter_basement():
	GameEvents.dialogue_ended.disconnect(_on_enter_basement)
	Transition.fade_out()
	Globals.transition_to_scene(load("res://scenes/cutscenes/end.tscn"))

func enable() -> void:
	if not interacting:
		return
	
	# Waiting a frame prevents the user from immediately interacting again when
	# clicking on this object while clicking to end the interaction dialogue
	# Maybe use a short cooldown timer instead?
	await get_tree().process_frame
	enabled = true
	interacting = false

func disable() -> void:
	enabled = false

func is_player_in_range() -> bool:
	var player = get_tree().get_first_node_in_group("Player")
	if player == null:
		return false
	
	var distance = global_position.distance_to(player.global_position)
	return distance < interaction_range
