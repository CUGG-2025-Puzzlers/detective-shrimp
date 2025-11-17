extends TextureRect

var input1
var input2

func _ready():
	input1 = get_node("EndPanel1")
	input2 = get_node("EndPanel2")
	material.set_shader_parameter("strength", 1)

func check_state():
	set_meta("state", input1.get_meta("state") && input2.get_meta("state"))
	print(get_meta("state"))
	if get_meta("state"):
		material.set_shader_parameter("strength", 0)
	else:
		material.set_shader_parameter("strength", 1)
