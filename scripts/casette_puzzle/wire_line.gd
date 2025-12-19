class_name WireLine
extends Line2D

@onready var center
@onready var max_length

func _ready() -> void:
	# Adjusts the position to be at the center right of the parent for accurate lines
	var parent = get_parent()
	center = parent.size / 2
	position.x = parent.size.x
	position.y = center.y
	max_length = parent.max_length

