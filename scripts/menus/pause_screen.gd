extends Menu

@onready var _resume_button: Button = %ResumeButton
@onready var _options_button: Button = %OptionsButton
@onready var _quit_button: Button = %QuitButton

func _ready() -> void:
	_resume_button.pressed.connect(_on_resume_pressed)
	_options_button.pressed.connect(_on_options_pressed)
	_quit_button.pressed.connect(_on_quit_pressed)

## Event Handler for when the resume button is pressed.
## Resumes the game
func _on_resume_pressed() -> void:
	print("Resuming Shrimptective!")
	get_tree().change_scene_to_file("res://scenes/main_level.tscn")
	# Main.close_menu()

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
