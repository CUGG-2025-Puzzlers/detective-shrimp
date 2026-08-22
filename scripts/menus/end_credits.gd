extends Menu

@onready var _main_menu_button: Button = %MainMenuButton
@onready var _quit_button     : Button = %QuitButton

func _ready() -> void:
	_main_menu_button.pressed.connect(_on_main_menu_pressed)
	_quit_button.pressed.connect(_on_quit_pressed)

## Event Handler for when the main menu button is pressed
## Returns the player to the main menu
func _on_main_menu_pressed() -> void:
	pass

## Event Handler for when the quit button is pressed
## Quits the application
func _on_quit_pressed() -> void:
	pass
