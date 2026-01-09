extends Area2D

@export var victory_delay: float = 1.0  # Seconds before showing victory

var victory_triggered: bool = false

func _ready():
	add_to_group("target")

func on_light_hit():
	# Trigger victory after a delay
	if not victory_triggered:
		victory_triggered = true
		
		# Change the light beam color to green
		var light_source = get_tree().get_first_node_in_group("light_source")
		if light_source:
			var beam = light_source.get_node("Line2D")
			beam.default_color = Color(0, 1, 0)  # Green
		
		await get_tree().create_timer(victory_delay).timeout
		trigger_victory()

func trigger_victory():
	print("VICTORY! Puzzle solved!")
	
	# Option 1: Load next level
	# get_tree().change_scene_to_file("res://next_level.tscn")
	
	# Option 2: Show victory UI
	# get_tree().call_group("ui", "show_victory_screen")
	
	# Option 3: Restart current level
	# get_tree().reload_current_scene()
	
	# For now, just pause and print
	get_tree().paused = true
