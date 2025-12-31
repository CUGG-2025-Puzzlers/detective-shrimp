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
		
	dialogue.append(Dialogue.new("???", "I can’t wait to see Henry! "))
	dialogue.append(Dialogue.new("???", "I’ll tell him about my new job. The library was so boring."))
	dialogue.append(Dialogue.new("???", "I’m a... Shrimptective."))
	dialogue.append(Dialogue.new("Shrimptective", "But we’ll have to see whether he’s home. I haven’t told him that I’m coming over."))
	dialogue.append(Dialogue.new("Shrimptective", "I wanted to surprise him! I even made his favorite salad. He eats healthy, unlike me."))
	dialogue.append(Dialogue.new("Shrimptective", "I can already imagine the smile on his face. It’ll be just like the good old days."))
	# [pause]
	dialogue.append(Dialogue.new("Shrimptective", "We’ll play games, read comics, all day, all summer. And now that we’re all grown up, we don’t have anyone nagging us!"))
	dialogue.append(Dialogue.new("Shrimptective", "Oh, there’s the house! It looks just like I remember."))

	# [game start, out of house scene]
	dialogue.append(Dialogue.new("Shrimptective", "Anyone home?"))
	dialogue.append(Dialogue.new("Shrimptective", "I guess I’ll go in first to wait for him. The spare key should be in the Mailbox"))

	# [mailbox interact]
	dialogue.append(Dialogue.new("Shrimptective", "I see the key in here, but it’s blocked by mail."))
	dialogue.append(Dialogue.new("Shrimptective", "I’ll need to rearrange the packages to get the key."))

	# [win klotski, get key]
	dialogue.append(Dialogue.new("Shrimptective", "Phew, that was tough."))

	# [door opens]
	# [walks in, fade out]
	# [fade in]
	index = 0
	GameEvents.dialogue_ended.connect(continueDialogue)

	for i in range(4000):
		await Engine.get_main_loop().process_frame
	GameEvents.dialogue_opened.emit()
	GameEvents.dialogue.emit(dialogue[index].speaker_name, dialogue[index].dialogue_text)

func continueDialogue() -> void:
	index += 1
	if (index >= dialogue.size()):
		for i in range(4000):
			await Engine.get_main_loop().process_frame
		GameEvents.dialogue_closed.emit()
	else:
		for i in range(4000):
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
