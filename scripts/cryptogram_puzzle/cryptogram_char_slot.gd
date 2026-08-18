class_name CryptogramCharSlot
extends Control

const CHAR_SLOT_SCENE: PackedScene = preload("res://scenes/cryptogram_puzzle/cryptogram_char_slot.tscn")

var is_editable: bool
var is_selected: bool
var letter_group: CryptogramGroup

static func new(editable: bool, group: CryptogramGroup) -> CryptogramCharSlot:
	var char_slot = CHAR_SLOT_SCENE.instantiate()
	char_slot.is_editable = editable
	char_slot.letter_group = group
	return char_slot

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

#region Event Handlers

## Event Handler for when the mouse has entered this char slot's area
func _on_mouse_entered() -> void:
	pass

## Event Handler for when the mouse has exited this char slot's area
func _on_mouse_exited() -> void:
	pass

func _on_click() -> void:
	GameEvents.select_group(letter_group)

#endregion

func select() -> void:
	pass

func deselect() -> void:
	pass

func set_letter(letter: String) -> void:
	pass
