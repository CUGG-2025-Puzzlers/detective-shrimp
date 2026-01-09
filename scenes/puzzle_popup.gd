extends CanvasLayer

# Export the puzzle scene paths
@export var puzzle_scenes: Dictionary = {
	"light_bending": "res://puzzles/LightBendingPuzzle.tscn",
	"puzzle_2": "res://puzzles/puzzle_2.tscn",
	"puzzle_3": "res://puzzles/puzzle_3.tscn",
	"puzzle_4": "res://puzzles/puzzle_4.tscn",
	"puzzle_5": "res://puzzles/puzzle_5.tscn"
}

# UI References
@onready var overlay: ColorRect = $Overlay
@onready var puzzle_container: Control = $PuzzleContainer
@onready var close_button: Button = $PuzzleContainer/CloseButton

var current_puzzle: Node = null
var player_can_move: bool = true

func _ready():
	# Initially hide the popup
	hide_popup()
	
	# Connect close button
	if close_button:
		close_button.pressed.connect(_on_close_pressed)
	
	# Add to a group so it can be accessed globally
	add_to_group("puzzle_popup")

func show_popup(puzzle_name: String):
	# Check if puzzle exists
	if not puzzle_scenes.has(puzzle_name):
		push_error("Puzzle '" + puzzle_name + "' not found!")
		return
	
	# Load and instantiate the puzzle
	var puzzle_scene = load(puzzle_scenes[puzzle_name])
	if puzzle_scene == null:
		push_error("Could not load puzzle scene: " + puzzle_scenes[puzzle_name])
		return
	
	current_puzzle = puzzle_scene.instantiate()
	puzzle_container.add_child(current_puzzle)
	
	# Show the overlay and container
	overlay.visible = true
	puzzle_container.visible = true
	
	# Disable player movement
	disable_player_movement()
	
	# Pause the main game but not the popup
	get_tree().paused = true
	process_mode = Node.PROCESS_MODE_ALWAYS

func hide_popup():
	# Remove current puzzle
	if current_puzzle:
		current_puzzle.queue_free()
		current_puzzle = null
	
	# Hide UI
	overlay.visible = false
	puzzle_container.visible = false
	
	# Re-enable player movement
	enable_player_movement()
	
	# Unpause the game
	get_tree().paused = false

func _on_close_pressed():
	hide_popup()

func disable_player_movement():
	# Call this on your player node if it exists
	var player = get_tree().get_first_node_in_group("player")
	if player and player.has_method("disable_movement"):
		player.disable_movement()
	player_can_move = false

func enable_player_movement():
	# Re-enable player movement
	var player = get_tree().get_first_node_in_group("player")
	if player and player.has_method("enable_movement"):
		player.enable_movement()
	player_can_move = true

# Function to be called when puzzle is completed
func on_puzzle_completed():
	print("Puzzle completed!")
	hide_popup()
	# You can add rewards, unlock doors, etc. here
