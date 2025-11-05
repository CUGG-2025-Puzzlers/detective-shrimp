extends Node

class Dialogue:
	var speaker_name: String
	var dialogue_text: String
	
	func _init(name: String, text: String) -> void:
		speaker_name = name
		dialogue_text = text

var dialogue = []
var index

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.dialogue_opened.connect(onOpen)
	GameEvents.dialogue_closed.connect(onClose)
	GameEvents.dialogue.connect(onDialogue)
	GameEvents.dialogue_started.connect(onDisplayStart)
	GameEvents.dialogue_ended.connect(onDisplayEnd)
	
	dialogue.append(Dialogue.new("Joseph", "Hey team, how do you guys like this?"))
	dialogue.append(Dialogue.new("Dominic", "Whoa, that's so sick! You're actually cooking."))
	dialogue.append(Dialogue.new("Huajin", "Wait, what about our pictures?"))
	dialogue.append(Dialogue.new("Mouad", "We are all Cameron..."))
	index = 0
	GameEvents.dialogue_ended.connect(continueDialogue)
	
	for i in range(2500):
		await Engine.get_main_loop().process_frame
	GameEvents.dialogue_opened.emit()
	GameEvents.dialogue.emit(dialogue[index].speaker_name, dialogue[index].dialogue_text)

func continueDialogue() -> void:
	index += 1
	if (index >= dialogue.size()):
		for i in range(2500):
			await Engine.get_main_loop().process_frame
		GameEvents.dialogue_closed.emit()
	else:
		for i in range(2500):
			await Engine.get_main_loop().process_frame
		GameEvents.dialogue.emit(dialogue[index].speaker_name, dialogue[index].dialogue_text)
	
	pass

func onOpen() -> void:
	print_debug("Opened Dialogue")

func onClose() -> void:
	print_debug("Closed Dialogue")

func onDialogue(speaker: String, text: String):
	print_debug("Displayed \"%s\" by %s" % [text, speaker])

func onDisplayStart() -> void:
	print_debug("Started Dialogue")

func onDisplayEnd() -> void:
	print_debug("Ended Dialogue")
