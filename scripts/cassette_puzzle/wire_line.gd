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
	add_point(Vector2(-center.x - 2, 0))
	add_point(Vector2.ZERO)
	add_point(get_local_mouse_position())

# Moves the wire end to follow the mouse, clamped by max_length
func adjust() -> void:
	if get_point_count() < 3:
		return
	
	var mouse_pos = get_local_mouse_position()
	
	# Clamps the wire length to max_length
	if  mouse_pos.length() > max_length:
		set_point_position(2, mouse_pos.normalized() * max_length)
	else:
		set_point_position(2, mouse_pos)

# Clears the wire by removing all points
func clear() -> void:
	clear_points()

# Attaches the end of the wire to the given positions
func attach(input: GateInput) -> void:
	if get_point_count() < 3:
		return
	
	var input_edge = input.global_position - global_position
	input_edge.y += input.size.y / 2
	var input_center = input_edge
	input_center.x += input.size.x / 2
	set_point_position(2, input_edge)
	add_point(input_center)

#endregion
