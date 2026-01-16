extends StaticBody2D
class_name WallBlock

# Color of this wall block (should match its controlling shrimp)
@export var block_color: Color = Color.RED

func _ready():
	# Set visual color
	modulate = block_color
	
	# Add to group for identification
	add_to_group("wall_block")
	
	print("WallBlock '%s' initialized with color %s" % [name, block_color])

# Helper to check if this wall is currently blocking light
func is_blocking() -> bool:
	for child in get_children():
		if child is CollisionShape2D:
			return not child.disabled
	return false
