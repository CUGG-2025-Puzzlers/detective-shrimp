extends Control

const FAST_TEXT_SPEED = 30
const NORMAL_TEXT_SPEED = 45
const SLOW_TEXT_SPEED = 60

var text_speed: int = NORMAL_TEXT_SPEED
var typing: bool = false

var cur_dialogue: Dialogue

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.dialogue_started.connect(_on_dialogue_started)
	close()

#region Event Handlers

func _input(event):
	if not visible:
		return
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			_on_mouse_down()

func _on_dialogue_started(dialogue: Dialogue):
	open(dialogue)
	displayNextLine()

func _on_mouse_down():
	if cur_dialogue.cur_line < cur_dialogue.lines.size():
		displayNextLine()
		return
	
	close()

#endregion

#region Display

func open(dialogue):
	visible = true
	cur_dialogue = dialogue

func close():
	visible = false
	
	if cur_dialogue == null:
		return
	
	cur_dialogue.cur_line = 0
	cur_dialogue = null

func displayNextLine():
	displayText(cur_dialogue.lines[cur_dialogue.cur_line])
	cur_dialogue.cur_line += 1

func displayText(line: DialogueLine) -> void:
	if (typing || !visible):
		return
	
	typing = true
	$%Portrait.texture = line.speaker_portrait
	$%Name.set_text(line.speaker_name)
	$%Text.clear()
	
	for c in line.text:
		$%Text.add_text(c)
		for i in range(text_speed):
			await Engine.get_main_loop().process_frame
	
	typing = false
