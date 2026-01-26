extends Area2D

# Set this in Inspector to point to the wall block (e.g., Shrimp_Block_1)
@export var wall_to_control: NodePath

# Color of this shrimp
@export var shrimp_color: Color = Color.RED

var is_activated: bool = false
var controlled_wall: Area2D = null

func _ready():
	# Add to shrimp group
	add_to_group("color_shrimp")
	
	# Set visual color if you have a Sprite2D or ColorRect
	if has_node("Sprite2D"):
		$Sprite2D.modulate = shrimp_color
	
	# Get reference to the wall block this controls
	if wall_to_control:
		controlled_wall = get_node(wall_to_control)
		if controlled_wall:
			print("✓ Shrimp '%s' linked to wall '%s'" % [name, controlled_wall.name])
		else:
			push_error("Shrimp '%s' could not find wall at path: %s" % [name, wall_to_control])
	else:
		push_warning("Shrimp '%s' has no wall_to_control set!" % name)

# Called by raycast when light hits this shrimp
func on_light_hit():
	if is_activated:
		return
	
	print("💡 Light hit shrimp '%s'" % name)
	activate()

func activate():
	is_activated = true

	if controlled_wall:
		print("  → Making wall '%s' transparent" % controlled_wall.name)
		make_wall_transparent()

func make_wall_transparent():
	# Make wall semi-transparent
	var transparent_color = Color(shrimp_color.r, shrimp_color.g, shrimp_color.b, 0.3)
	controlled_wall.modulate = transparent_color
	
	# Disable collision so light passes through
	for child in controlled_wall.get_children():
		if child is CollisionShape2D:
			child.set_deferred("disabled", true)
			print("    ✓ Wall collision disabled")

# For puzzle reset
func deactivate():
	is_activated = false

	if controlled_wall:
		# Reset wall to full opacity
		controlled_wall.modulate.a = 1.0
		# Re-enable collision
		for child in controlled_wall.get_children():
			if child is CollisionShape2D:
				child.disabled = false
