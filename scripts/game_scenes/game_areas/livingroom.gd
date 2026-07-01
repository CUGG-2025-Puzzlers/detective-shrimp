extends Scene

func _ready() -> void:
	GameEvents.dialogue_ended.connect(_on_dialogue_ended)

func _on_dialogue_ended(name: String):
	await get_tree().create_timer(2.5).timeout
	return
