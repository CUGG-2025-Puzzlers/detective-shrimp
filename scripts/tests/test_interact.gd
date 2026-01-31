extends Area2D

@export var puzzle_name: String = "light_bending"  # Which puzzle to trigger
@export var interaction_key: String = "ui_accept"  # E key or Space by default
@export var prompt_text: String = "Press E to interact"

var player_nearby: bool = false
var popup_system: CanvasLayer = null

func _ready():
	# Connect signals
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# Find the popup system
	await get_tree().process_frame  # Wait one frame for nodes to be ready
	popup_system = get_tree().get_first_node_in_group("puzzle_popup")

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_nearby = true
		show_interaction_prompt()

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_nearby = false
		hide_interaction_prompt()

func _process(_delta):
	if player_nearby and Input.is_action_just_pressed(interaction_key):
		trigger_puzzle()

func trigger_puzzle():
	if popup_system:
		popup_system.show_popup(puzzle_name)
	else:
		push_error("Puzzle popup system not found!")

func show_interaction_prompt():
	# You can create a label here or call a UI manager
	print(prompt_text)
	# Example: get_tree().call_group("ui", "show_prompt", prompt_text)

func hide_interaction_prompt():
	# Hide the interaction prompt
	# Example: get_tree().call_group("ui", "hide_prompt")
	pass
