extends CanvasLayer

@onready var control_node: Control = $Control
@onready var quest_label: RichTextLabel = $Control/PanelContainer/MarginContainer/QuestLabel

var current_quest_index: int = 0
var is_transitioning: bool = false
var player_active: bool = false

var quests: Array[Dictionary] = [
	{
		"text": "Interact with the mailbox",
		"signal": "dialogue_ended",
		"trigger": null,
	},
	{
		"text": "Get the key from the mailbox",
		"signal": "puzzle_finished",
		"trigger": GameData.PuzzleType.Key,
	},
	{
		"text": "Use the key to go inside the house",
		"signal": "scene_changed",
		"trigger": null,
	},
]

func _ready() -> void:
	# Start hidden - will show when player is active
	control_node.visible = false

	GameEvents.dialogue_ended.connect(_on_dialogue_ended)
	GameEvents.puzzle_started.connect(_on_puzzle_started)
	GameEvents.puzzle_finished.connect(_on_puzzle_finished)
	GameEvents.scene_changed.connect(_on_scene_changed)
	Globals.requested_player_show.connect(_on_player_show)
	Globals.requested_player_hide.connect(_on_player_hide)

func _on_player_show(pos: Vector2) -> void:
	player_active = true
	if current_quest_index < quests.size():
		control_node.visible = true
		_display_current_quest()

func _on_player_hide() -> void:
	player_active = false
	control_node.visible = false

func _on_dialogue_ended(name: String) -> void:
	_try_complete("dialogue_ended", null)

func _on_puzzle_started(puzzle: GameData.PuzzleType) -> void:
	_try_complete("puzzle_started", puzzle)

func _on_puzzle_finished(puzzle: GameData.PuzzleType) -> void:
	_try_complete("puzzle_finished", puzzle)

func _on_scene_changed(_scene_name: String) -> void:
	_try_complete("scene_changed", null)

func _try_complete(signal_name: String, trigger) -> void:
	if current_quest_index >= quests.size():
		return
	if is_transitioning:
		return

	var quest = quests[current_quest_index]

	# Check if signal matches
	if quest["signal"] != signal_name:
		return

	# Check if trigger matches
	if quest["trigger"] != null and quest["trigger"] != trigger:
		return

	_complete_current_quest()

func _complete_current_quest() -> void:
	is_transitioning = true
	control_node.visible = true
	var quest = quests[current_quest_index]

	# Show strikethrough
	quest_label.text = "[s]" + quest["text"] + "[/s]"

	# Wait for player to see the strikethrough
	await get_tree().create_timer(1.0).timeout

	# Fade out
	var tween = create_tween()
	tween.tween_property(control_node, "modulate:a", 0.0, 0.3)
	await tween.finished

	# Advance to next quest
	current_quest_index += 1
	_display_current_quest()

	# Fade in if there's a next quest and player is active
	if current_quest_index < quests.size() and player_active:
		control_node.visible = true
		tween = create_tween()
		tween.tween_property(control_node, "modulate:a", 1.0, 0.3)
		await tween.finished

	is_transitioning = false

func _display_current_quest() -> void:
	if current_quest_index >= quests.size():
		control_node.visible = false
		return

	control_node.modulate.a = 1.0
	quest_label.text = quests[current_quest_index]["text"]
