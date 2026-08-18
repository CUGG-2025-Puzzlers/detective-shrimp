class_name BankLetter
extends Label

const ENABLED_COLOR = Color(0.32, 0.123, 0.032)
const DISABLED_COLOR = Color(0.32, 0.123, 0.032, 0.25)

var enabled: bool = true

func _ready() -> void:
	GameEvents.letter_enabled.connect(_on_letter_enabled)
	GameEvents.letter_disabled.connect(_on_letter_disabled)

func _gui_input(event: InputEvent) -> void:
	if event is not InputEventMouseButton:
		return
	
	if event.button_index != MOUSE_BUTTON_LEFT:
		return
	
	if not event.is_pressed():
		return
	
	_on_click()

## Event Handler for when this bank letter has been clicked. 
## Emits a signal that a bank letter has been clicked
func _on_click() -> void:
	if not enabled:
		return
	
	GameEvents.click_bank_letter(text[0])

## Event Handler for when a letter has been enabled. 
## Enables this bank letter
func _on_letter_enabled(letter: String) -> void:
	if letter != text[0]:
		return
	
	enabled = true
	add_theme_color_override("font_color", ENABLED_COLOR)

## Event Handler for when a letter has been disabled. 
## Disables this bank letter
func _on_letter_disabled(letter: String) -> void:
	if letter != text[0]:
		return
	
	enabled = false
	add_theme_color_override("font_color", DISABLED_COLOR)
