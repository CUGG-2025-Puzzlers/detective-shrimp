extends Line2D

var dragging = false
var hovered_panel = null
@onready var button = get_node("Button") 
var origin
var connected_panel = null
var gate 

func _ready():
	width = 20
	gate = get_parent()
	origin = position
	print(origin)
	set_meta("state", gate.get_meta("state"))

	var children1 = get_node("/root").get_child(0).get_children()
	print(children1)
	for child in children1:
		if "Gate" in child.get_name():
			var children2 = child.get_children()
			for child2 in children2:
				if "EndPanel" in child2.get_name():
					child2._panel_enter.connect(_on_panel_enter)
					child2._panel_exit.connect(_on_panel_exit)

func _process(delta):
	if dragging:
		set_point_position(1,to_local(get_global_mouse_position()))
	
func _on_button_button_down():
	dragging = true
	set_point_position(0, Vector2(30,30))

func _on_button_button_up():
	print("button up")
	var offset = Vector2(0,0)
	dragging = false
	if hovered_panel == null:
		set_point_position(0, Vector2(0,0))
		set_point_position(1, Vector2(0,0))
		if (connected_panel != null):
			connected_panel.set_meta("state", false)
			connected_panel.get_parent().check_state()
	else:
		print("snapping!")
		offset = Vector2(30,30)
		set_point_position(1, to_local(hovered_panel.global_position) + offset)
		hovered_panel.set_meta("state", get_meta("state"));
		hovered_panel.get_parent().check_state()
	button.position = get_point_position(1) - offset - button.position
	if hovered_panel == null:
		button.position = Vector2(0,0)
	connected_panel = hovered_panel
	var children = get_node("../").get_children()
	for child in children:
		if "Gate" in child.get_name():
			child.check_state()

func _on_panel_enter(panel: Panel):
	print(panel)
	hovered_panel = panel
	
func _on_panel_exit():
	hovered_panel = null
	
func update_state():
	connected_panel.set_meta("state", get_meta("state"))
	
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
