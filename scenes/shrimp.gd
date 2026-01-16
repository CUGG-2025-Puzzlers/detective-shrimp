extends Area2D
class_name ColorShrimp

# Set this in the Inspector to point to the wall this shrimp controls
@export var wall_to_control: NodePath

# Color of this shrimp (and its matching wall)
@export var shrimp_color: Color = Color.RED

var is_activated: bool = false
var controlled_wall: Node = null

func _ready():
	# Add to shrimp group (NOT target - we want light to continue through)
	add_to_group("color_shrimp")
	add_to_group("reflector")  # So light can interact with it
	
	# Set visual color
	modulate = shrimp_color
	
	# Find and store reference to controlled wall
	if wall_to_control:
		controlled_wall = get_node(wall_to_control)
		if controlled_wall:
			print("Shrimp linked to wall: ", controlled_wall.name)
		else:
			push_error("Could not find wall at path: ", wall_to_control)

# Called by raycast when light hits this shrimp
func on_light_hit():
	if not is_activated:
		activate()

func activate():
	if is_activated:
		return
	
	is_activated = true
	print("💡 Shrimp activated! Color: ", shrimp_color)
	
	# Make the controlled wall transparent and non-solid
	if controlled_wall:
		make_wall_transparent(controlled_wall)
	
	# Visual feedback - fade the shrimp
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.4, 0.3)
	
	# Optional: Play a sound effect here
	# $AudioStreamPlayer.play()

func make_wall_transparent(wall: Node):
	# Make wall semi-transparent visually
	wall.modulate = Color(shrimp_color.r, shrimp_color.g, shrimp_color.b, 0.3)
	
	# Disable all collision shapes so light can pass through
	for child in wall.get_children():
		if child is CollisionShape2D:
			child.set_deferred("disabled", true)
	
	print("  ✓ Wall ", wall.name, " is now transparent!")

# For resetting puzzle
func deactivate():
	is_activated = false
	modulate = shrimp_color
	
	if controlled_wall:
		# Restore wall
		controlled_wall.modulate = shrimp_color
		for child in controlled_wall.get_children():
			if child is CollisionShape2D:
				child.disabled = false
