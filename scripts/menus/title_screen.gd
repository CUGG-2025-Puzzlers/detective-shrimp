extends Menu

@onready var _start_button  : Button = %StartButton
@onready var _options_button: Button = %OptionsButton
@onready var _quit_button   : Button = %QuitButton

func _ready() -> void:
	_start_button.pressed.connect(_on_start_pressed)
	_options_button.pressed.connect(_on_options_pressed)
	_quit_button.pressed.connect(_on_quit_pressed)

## Event Handler for when the start button is pressed.
## Starts the game
func _on_start_pressed() -> void:
	print("Starting Shrimptective!")
	GameEvents.request_menu_close()
	GameEvents.request_scene_change(UID.CAR_CUTSCENE)

## Event Handler for when the options button is pressed.
## Opens the Options Menu
func _on_options_pressed() -> void:
	print("Options have not yet been implemented... sorry!")
	pass # Replace with function body.

## Event Handler for when the quit button is pressed.
## Quits the application
func _on_quit_pressed() -> void:
	print("Quitting the game... bye!")
	get_tree().quit()
