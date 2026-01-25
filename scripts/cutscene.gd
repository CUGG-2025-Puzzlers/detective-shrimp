extends Node

@export var background_music: AudioStream
@export var dialogue: Array[Dialogue]
@export var dialogue_delay: float = 2.0

var cur_dialogue = 0

func _ready() -> void:
	if (background_music != null):
		AudioManager.play_background_music(background_music, 5)
	
	if (dialogue.size() > 0):
		await get_tree().create_timer(dialogue_delay).timeout
		_play_dialogue()
		GameEvents.dialogue_ended.connect(_on_dialogue_ended)

func _on_dialogue_ended():
	if (cur_dialogue >= dialogue.size()):
		GameEvents.dialogue_ended.disconnect(_on_dialogue_ended)
		return
	
	_play_dialogue()

func _play_dialogue():
	GameEvents.start_dialogue(dialogue[cur_dialogue])
	cur_dialogue += 1
