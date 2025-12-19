extends Line2D

var dragging = false
var hovered_panel = null
@onready var button = get_node("Button") 
@onready var chkbtn = get_node("CheckButton")
var origin
var connected_panel = null
var max_length = 500
var length
var wire_end

func _ready():
	origin = position
	print(origin)
	set_meta("state", chkbtn.button_pressed)
	var children1 = get_node("../").get_children()
	for child in children1:
		if "Gate" in child.get_name():
			var children2 = child.get_children()
			for child2 in children2:
				if "EndPanel" in child2.get_name():
					child2._panel_enter.connect(_on_panel_enter)
					child2._panel_exit.connect(_on_panel_exit)

func _process(delta):
	if dragging:
		wire_end = get_global_mouse_position()
		if (get_point_count() > 1):
			length = get_point_position(1).length()
			if (length > max_length):
				wire_end = wire_end.normalized() * max_length

		set_point_position(1,wire_end - origin)
	
func _on_button_button_down():
	dragging = true
	set_point_position(0, Vector2(15,15))

func _on_button_button_up():
	var offset = Vector2(0,0)
	dragging = false
	if hovered_panel == null:
		set_point_position(0, Vector2(0,0))
		set_point_position(1, Vector2(0,0))
		print(connected_panel)
		if (connected_panel != null):
			connected_panel.set_meta("state", false)
	else:
		print("snapping!")
		offset = Vector2(15,15)
		set_point_position(1, hovered_panel.global_position - origin + offset)
		hovered_panel.set_meta("state", get_meta("state"));
	button.position = get_point_position(1) - offset
	connected_panel = hovered_panel
	var children = get_node("../").get_children()
	for child in children:
		if "Gate" in child.get_name():
			child.check_state()

func _on_panel_enter(panel: Panel):
	if (to_global(get_point_position(1)).distance_to(panel.global_position) < 50):
		hovered_panel = panel
	
func _on_panel_exit():
	hovered_panel = null
	
"""
func _on_end_panel_1_mouse_entered():
	hovered_panel = get_node("../Gate1/EndPanel1")

func _on_end_panel_1_mouse_exited():
	hovered_panel = null
		
func _on_end_panel_2_mouse_entered():
	hovered_panel = get_node("../Gate1/EndPanel2")

func _on_end_panel_2_mouse_exited():
	hovered_panel = null
"""

func _on_check_button_toggled(toggled_on: bool):
	set_meta("state", toggled_on)
	if (connected_panel != null):
		connected_panel.set_meta("state", toggled_on)
	var children = get_node("../").get_children()
	for child in children:
		if "Gate" in child.get_name():
			child.check_state()
