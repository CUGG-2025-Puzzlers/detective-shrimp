extends Control

const FAST_TEXT_SPEED = 0.025
const NORMAL_TEXT_SPEED = 0.05
const SLOW_TEXT_SPEED = 0.075
const END_OF_TEXT_PAUSE = 0.25

var text_speed: float = NORMAL_TEXT_SPEED
var skip_typing: bool = false

var cur_dialogue: Dialogue
var cur_line: int = 0
var cur_char_index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.dialogue_started.connect(_on_dialogue_started)
	$%TextTimer.timeout.connect(_on_timer_finished)
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

func _on_mouse_down():
	if $%TextTimer.is_stopped():
		cur_line += 1
		if cur_line >= cur_dialogue.lines.size():
			close()
			return
		
		displayNextLine()
		return
	
	if cur_char_index < cur_dialogue.lines[cur_line].text.length():
		skip_typing = true
		return

func _on_timer_finished():
	if skip_typing:
		cur_char_index = cur_dialogue.lines[cur_line].text.length() + 1
		$%Text.visible_characters = cur_char_index
		$%TextTimer.start(END_OF_TEXT_PAUSE)
		skip_typing = false
		return
	
	if cur_char_index < cur_dialogue.lines[cur_line].text.length():
		cur_char_index += 1
		$%Text.visible_characters = cur_char_index
		return
	
	if cur_char_index == cur_dialogue.lines[cur_line].text.length():
		$%TextTimer.start(END_OF_TEXT_PAUSE)
		return
	
	$%TextTimer.stop()

#endregion

#region Display

func open(dialogue):
	visible = true
	cur_dialogue = dialogue
	displayNextLine()

func close():
	visible = false
	
	if cur_dialogue == null:
		return
	
	cur_dialogue.cur_line = 0
	cur_dialogue = null

func displayNextLine():
	if !visible:
		return
	
	var line_data = cur_dialogue.lines[cur_line]
	$%Text.visible_characters = 0
	$%Portrait.texture = line_data.speaker_portrait
	$%Name.set_text(line_data.speaker_name)
	$%Text.set_text(line_data.text)
	
	cur_char_index = 0
	$%TextTimer.wait_time = text_speed
	$%TextTimer.start()
