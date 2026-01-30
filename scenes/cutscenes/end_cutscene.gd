extends Sprite2D

var cur_texture = -1
@export var textures: Array[Texture2D]

func _ready() -> void:
	Player.visible = false
	GameEvents.dialogue_ended.connect(_on_dialogue_ended)
	GameEvents.dialogue_line_ended.connect(_on_dialogue_line_ended)

func _on_dialogue_ended():
	if cur_texture == 4:
		Transition.fade_out()
	await get_tree().create_timer(2.5).timeout
	return

func update_texture():
	if (cur_texture < textures.size()):
		cur_texture += 1
		if cur_texture == 1:
			Transition.fade_in()
		texture = textures[cur_texture]

func _on_dialogue_line_ended(cur_line: int):
	print(cur_line)
	if cur_line == 0 or cur_line == 6 or cur_line == 11 or cur_line == 16:
		update_texture()
	return
