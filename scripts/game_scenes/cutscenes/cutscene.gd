extends GameScene

@export var cutscene: Globals.Cutscene
@export var dialogue: Array[Dialogue]
@export var dialogue_delay: float = 2.0

var cur_dialogue = 0

func _ready() -> void:
	super._ready()
	if (dialogue.size() == 0):
		return
	
	await get_tree().create_timer(dialogue_delay).timeout
	_play_dialogue()
	GameEvents.dialogue_ended.connect(_on_dialogue_ended)

func _on_dialogue_ended(name: String):
	if (cur_dialogue >= dialogue.size()):
		GameEvents.dialogue_ended.disconnect(_on_dialogue_ended)
		Globals.end_cutscene(cutscene)
		return
	
	await get_tree().create_timer(dialogue_delay).timeout
	_play_dialogue()

func _play_dialogue():
	GameEvents.start_dialogue(dialogue[cur_dialogue])
	cur_dialogue += 1
