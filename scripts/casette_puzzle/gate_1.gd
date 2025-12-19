extends TextureRect

var input1
var input2
var output

func _ready():
	input1 = get_child(0)
	input2 = get_child(1)
	output = get_child(2)
	
	var v 
	if (get_meta("state")):
		v = 0
	else:
		v = 1
	
	material.set_shader_parameter("strength", v)

func check_state():
	set_meta("state", input1.get_meta("state") && input2.get_meta("state"))
	output.set_meta("state", input1.get_meta("state") && input2.get_meta("state"))
	
	if (output.connected_panel != null):
		output.update_state()
		output.connected_panel.get_parent().check_state()

	if get_meta("state"):
		material.set_shader_parameter("strength", 0)
	else:
		material.set_shader_parameter("strength", 1)
