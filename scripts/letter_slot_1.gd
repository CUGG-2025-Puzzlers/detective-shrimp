extends Control


@onready var button: Button = $hover
@onready var line_edit := $LetterIn2

func _ready():
	# Connect the built-in "pressed" signal
	button.pressed.connect(_on_hover_pressed)
	line_edit.text = ""

func _on_hover_pressed() -> void:
	print("button pressed!")
	
	# Give it keyboard focus
	line_edit.grab_focus()
	
	# Optional: place caret at the end of the text
	line_edit.caret_column = line_edit.text.length()
