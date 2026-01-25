extends Area2D

# Color of this wall block (should match its controlling shrimp)
@export var block_color: Color = Color.RED

func _ready():
	# Set visual color if you have a Sprite2D
	if has_node("Sprite2D"):
		$Sprite2D.modulate = block_color
	
	# Add to group
	add_to_group("shrimp_block")
	
	print("Shrimp_Block '%s' initialized with color %s" % [name, block_color])
