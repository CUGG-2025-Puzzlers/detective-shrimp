extends Control

@export var speaker_title_node: NodePath
@export var dialogue_text_node: NodePath

@onready var speaker = get_node(speaker_title_node)
@onready var text = get_node(dialogue_text_node)

const FAST_TEXT_SPEED = 30
const NORMAL_TEXT_SPEED = 45
const SLOW_TEXT_SPEED = 60

var text_speed: int = NORMAL_TEXT_SPEED
var typing: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.dialogue_opened.connect(open)
	GameEvents.dialogue_closed.connect(close)
	GameEvents.dialogue.connect(displayText)
	close()

func open() -> void:
	visible = true
	
func close() -> void:
	visible = false

func displayText(speaker_name: String, dialogue: String) -> void:
	if (typing || !visible):
		return
	
	typing = true
	speaker.set_text(speaker_name)
	text.clear()
	
	for c in dialogue:
		text.add_text(c)
		for i in range(text_speed):
			await Engine.get_main_loop().process_frame
	typing = false
