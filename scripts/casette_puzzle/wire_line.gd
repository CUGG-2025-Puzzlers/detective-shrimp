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

#region Wire Drawing

# Starts the wire by adding a point to the center of the parent texture, another
# at the edge (where this object is placed), and one at the mouse position to
# follow the mouse
func start() -> void:
	add_point(Vector2(-center.x, 0))
	add_point(Vector2.ZERO)
	add_point(get_local_mouse_position())

#endregion
