extends Node

signal dialogue_started(dialogue: Dialogue)
signal dialogue_ended()

func start_dialogue(dialogue: Dialogue):
	dialogue_started.emit(dialogue)

func end_dialogue():
	dialogue_ended.emit()
