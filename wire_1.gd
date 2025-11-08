extends Line2D

var dragging = false

func _ready():
	add_point(Vector2(0,0), 0)
	add_point(Vector2(0,0), 1)

func _process(delta):
	if dragging:
		set_point_position(1,get_global_mouse_position())
	
func _on_button_button_down():
	dragging = true

func _on_button_button_up():
	dragging = false
	set_point_position(1, Vector2(0,0))
