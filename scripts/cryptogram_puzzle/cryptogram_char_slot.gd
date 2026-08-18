class_name CryptogramCharSlot
extends Control

var is_editable: bool
var is_selected: bool
var letter_group: CryptogramGroup

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
