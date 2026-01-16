extends TextureRect

@export var interaction_range: int
@export var dialogue: Dialogue
@export var event: GameEvents.EventTrigger

var interactable = false
var enabled = true

func _ready() -> void:
	mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN
	GameEvents.dialogue_started.connect(_on_dialogue_started)
	GameEvents.dialogue_ended.connect(_on_dialogue_ended)

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
	
	GameEvents.start_dialogue(dialogue)

func enable() -> void:
	enabled = true

func disable() -> void:
	enabled = false

func is_player_in_range() -> bool:
	var player = get_tree().get_first_node_in_group("Player")
	if player == null:
		return false
	
	var distance = global_position.distance_to(player.global_position)
	return distance < interaction_range
