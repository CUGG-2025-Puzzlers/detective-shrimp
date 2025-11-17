extends Line2D

var dragging = false
var hovered_panel = null
@onready var button = get_node("Button2") 
var origin
var connected_panel = null

func _ready():
	origin = position
	print(origin)
	set_meta("state", true)

func _process(delta):
	if dragging:
		set_point_position(1,get_global_mouse_position() - origin)
	
func _on_button_button_down():
	dragging = true

func _on_button_button_up():
	dragging = false
	if hovered_panel == null:
		set_point_position(1, Vector2(0,0))
		if (connected_panel != null):
			connected_panel.set_meta("state", false)
	else:
		print("snapping!")
		set_point_position(1, hovered_panel.global_position - origin)
		hovered_panel.set_meta("state", get_meta("state"));
	button.position = get_point_position(1)
	connected_panel = hovered_panel
	get_node("../Gate1").check_state()


func _on_end_panel_1_mouse_entered():
	hovered_panel = get_node("../Gate1/EndPanel1")

func _on_end_panel_1_mouse_exited():
	hovered_panel = null
		
func _on_end_panel_2_mouse_entered():
	hovered_panel = get_node("../Gate1/EndPanel2")

func _on_end_panel_2_mouse_exited():
	hovered_panel = null
