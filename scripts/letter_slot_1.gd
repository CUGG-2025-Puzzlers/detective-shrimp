extends Control

# Signal to tell the Game Manager "I changed, update the others!"
signal content_changed(new_text, group_id)

@onready var button: Button = $hover
@onready var line_edit: LineEdit = $hover/char
@onready var underline: ColorRect = $underline

var correct_letter: String = ""
var group_id: String = ""
var is_locked: bool = false

func _ready():
	button.pressed.connect(_on_hover_pressed)
	# Connect safely
	if not line_edit.text_changed.is_connected(_on_text_changed):
		line_edit.text_changed.connect(_on_text_changed)

# --- FIX IS HERE ---
# Changed 'hidden' to 'is_hidden' to fix the error
func setup(letter: String, is_hidden: bool):
	correct_letter = letter.to_upper()
	group_id = "LETTER_" + correct_letter 
	
	# Try to find the nodes
	var input_node = get_node_or_null("hover/char")
	var underline_node = get_node_or_null("underline")
	
	# SAFETY CHECK: If we can't find them, stop here so we don't crash
	if input_node == null:
		printerr("ERROR: Could not find node 'hover/char' in LetterSlot")
		return
	if underline_node == null:
		printerr("ERROR: Could not find node 'Underline' in LetterSlot. Check naming!")
		return
	
	if is_hidden:
		# It's a puzzle piece!
		input_node.text = ""
		input_node.editable = true
		input_node.focus_mode = Control.FOCUS_CLICK
		underline_node.visible = true
		is_locked = false
		add_to_group(group_id) 
	else:
		# It's a static letter
		input_node.text = correct_letter
		input_node.editable = false
		input_node.focus_mode = Control.FOCUS_NONE
		underline_node.visible = false
		is_locked = true

func _on_hover_pressed() -> void:
	if not is_locked:
		# print("button pressed!") # optional debug
		line_edit.grab_focus()
		line_edit.caret_column = line_edit.text.length()

func _on_text_changed(new_text: String) -> void:
	if is_locked: return
	
	# Force uppercase and single char
	new_text = new_text.to_upper()
	if new_text.length() > 1:
		new_text = new_text.right(1)
		# Prevent infinite loop
		line_edit.text_changed.disconnect(_on_text_changed)
		line_edit.text = new_text
		line_edit.caret_column = 1
		line_edit.text_changed.connect(_on_text_changed)
	
	content_changed.emit(new_text, group_id)

# Called by the Game Manager from OUTSIDE
func external_update(text_val: String):
	if not is_locked:
		if line_edit.text_changed.is_connected(_on_text_changed):
			line_edit.text_changed.disconnect(_on_text_changed)
		
		line_edit.text = text_val
		
		line_edit.text_changed.connect(_on_text_changed)
