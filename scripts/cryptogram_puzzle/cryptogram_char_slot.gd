class_name CryptogramCharSlot
extends Control

const CHAR_SLOT_SCENE: PackedScene = preload("res://scenes/cryptogram_puzzle/cryptogram_char_slot.tscn")
const UNDERSCORE_POS_SELECTED   : Vector2 = Vector2(0, 1)
const UNDERSCORE_POS_NONSELECTED: Vector2 = Vector2(0, 3)

@onready var _text      : Label = %Text
@onready var _underscore: Label = %Underscore
@onready var _highlight: ColorRect = %Highlight

var is_enabled: bool = false
var is_editable: bool
var is_selected: bool
var letter_group: CryptogramGroup

static func new_slot(editable: bool, group: CryptogramGroup) -> CryptogramCharSlot:
	var char_slot = CHAR_SLOT_SCENE.instantiate()
	char_slot.is_editable = editable
	char_slot.letter_group = group
	return char_slot

func _ready() -> void:
	_remove_highlight_effects()
	
	if is_editable:
		mouse_entered.connect(_on_mouse_entered)
		mouse_exited.connect(_on_mouse_exited)
	else:
		_underscore.visible = false

func _gui_input(event: InputEvent) -> void:
	if not is_enabled or not is_editable:
		return
	
	if not event is InputEventMouseButton:
		return
	
	var mouse_event = event as InputEventMouseButton
	if mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_LEFT:
		_on_click()

#region Event Handlers

## Event Handler for when the mouse has entered this char slot's area
func _on_mouse_entered() -> void:
	if not is_enabled or is_selected:
		return
	
	_apply_highlight_effects()

## Event Handler for when the mouse has exited this char slot's area
func _on_mouse_exited() -> void:
	if not is_enabled or is_selected:
		return
	
	_remove_highlight_effects()

func _on_click() -> void:
	GameEvents.select_group(letter_group)

#endregion

func _apply_highlight_effects() -> void:
	_underscore.position = UNDERSCORE_POS_SELECTED
	_highlight.visible = true

func _remove_highlight_effects() -> void:
	_underscore.position = UNDERSCORE_POS_NONSELECTED
	_highlight.visible = false

func enable() -> void:
	is_enabled = true

func disable() -> void:
	is_enabled = false

func select() -> void:
	is_selected = true
	_apply_highlight_effects()

func deselect() -> void:
	is_selected = false
	_remove_highlight_effects()

func set_letter(letter: String) -> void:
	_text.text = letter[0] if letter.length() > 1 else letter
