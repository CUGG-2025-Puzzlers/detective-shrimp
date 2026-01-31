class_name Interactable
extends TextureRect

@export var interaction_range: int
@export var dialogue: Dialogue

var enabled = true
var interactable = false
var interacting = false

var basement_dialogue: Dialogue
var painting_dialogue: Dialogue
var mid_nap: Dialogue
var end_nap: Dialogue
var post_nap: Dialogue
var grocery_light: Dialogue
var grocery_dark: Dialogue

func _ready() -> void:
	mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN
	GameEvents.dialogue_started.connect(_on_dialogue_started)
	GameEvents.dialogue_ended.connect(_on_dialogue_ended)
	
	basement_dialogue = preload("res://resources/dialogue/interact/living_room/basement_door.tres")
	painting_dialogue = preload("res://resources/dialogue/interact/living_room/painting_open.tres")
	mid_nap = preload("res://resources/dialogue/interact/living_room/mid_nap.tres")
	end_nap = preload("res://resources/dialogue/interact/living_room/end_nap.tres")
	post_nap = preload("res://resources/dialogue/interact/living_room/post_nap.tres")
	grocery_light = preload("res://resources/dialogue/interact/kitchen/grocery_light.tres")
	grocery_dark = preload("res://resources/dialogue/interact/kitchen/grocery_dark.tres")

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

func _on_dialogue_ended(name: String) -> void:
	enable()

#endregion

func interact() -> void:
	if not enabled or not interactable:
		return
	
	interacting = true
	interaction()

func interaction() -> void:	
	# Special interaction when Basement door is interacted with after 
	# the key is obtained from the safe.
	# Definitely not the best way to implement it, but I don't know 
	# how else to do it. - Cameron
	if name == "Basement Door" and GameEvents.safe:
		GameEvents.start_dialogue(basement_dialogue)
		GameEvents.dialogue_ended.connect(_on_enter_basement)
		return
	# I did it again.
	if name == "Painting" and GameEvents.letter_complete:
		$%Fallen_Painting.visible = true
		visible = false
		GameEvents.start_dialogue(painting_dialogue)
		return

	if name == "Couch": 
		if GameEvents.napped:
			GameEvents.start_dialogue(post_nap)
		else:
			GameEvents.napped = true
			GameEvents.start_dialogue(dialogue)
			GameEvents.dialogue_ended.connect(_on_nap_start)
		return
		
	if name == "Groceries": 
		if GameEvents.reflection_complete:
			GameEvents.grocery_list = true
			GameEvents.start_dialogue(grocery_light)
		else:
			GameEvents.start_dialogue(grocery_dark)
		return
		
	if name == "Upstairs":
		Transition.transition()
		await Transition.on_transition_finished
		Globals.transition_to_scene(load("res://scenes/background art/hallway.tscn"))
		return

	if name == "Downstairs":
		Transition.transition()
		await Transition.on_transition_finished
		Globals.transition_to_scene(load("res://scenes/background art/livingroom.tscn"))
		return
		
	if name == "Bedroom Door":
		Transition.transition()
		await Transition.on_transition_finished
		Globals.transition_to_scene(load("res://scenes/background art/bedroom.tscn"))
		return

	GameEvents.start_dialogue(dialogue)

func _on_nap_start(name: String):
	GameEvents.dialogue_ended.disconnect(_on_nap_start)
	Transition.fade_out()
	await get_tree().create_timer(1.2).timeout
	GameEvents.start_dialogue(mid_nap)
	GameEvents.dialogue_ended.connect(_on_nap_end)

func _on_nap_end(name:String):
	GameEvents.dialogue_ended.disconnect(_on_nap_end)
	Transition.fade_in()
	await get_tree().create_timer(1.2).timeout
	GameEvents.start_dialogue(end_nap)

func _on_enter_basement(name: String):
	GameEvents.dialogue_ended.disconnect(_on_enter_basement)
	Transition.fade_out()
	await get_tree().create_timer(1).timeout
	Globals.transition_to_scene(load("res://scenes/cutscenes/end.tscn"))

func enable() -> void:
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
