extends TextureRect

var input1
var input2

func _ready():
	input1 = get_child(0)
	input2 = get_child(1)
	
	var v 
	print(get_meta("state"))
	if (get_meta("state")):
		v = 0
	else:
		v = 1
	
	material.set_shader_parameter("strength", v)

func check_state():
	set_meta("state", (input1.get_meta("state") && !input2.get_meta("state")) || (!input1.get_meta("state") && input2.get_meta("state")))
	get_child(2).set_meta("state", input1.get_meta("state") && input2.get_meta("state"))
	if get_meta("state"):
		material.set_shader_parameter("strength", 0)
	else:
		material.set_shader_parameter("strength", 1)
