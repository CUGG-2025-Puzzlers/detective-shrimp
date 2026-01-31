extends VBoxContainer

signal puzzle_solved

@export var letter_slot_scene: PackedScene
@export var difficulty_level: int = 3 

# No more fancy "set" logic. It just holds text now.
@export_multiline var text_content: String = """WE OFTEN STARE SO INTENTLY AT THE
REGRETS HIDDEN BEHIND THE FRAME THAT WE FORGET
THE PAINTING OF OUR LIFE IS STILL BEING CREATED."""

var hidden_chars_list: Array = []

func _ready() -> void:
	# Because we aren't a tool anymore, we ALWAYS run this at start
	randomize_puzzle_logic()
	generate_puzzle()

func randomize_puzzle_logic():
	var unique_chars = []
	
	for character in text_content.to_upper():
		if character >= "A" and character <= "Z":
			if not character in unique_chars:
				unique_chars.append(character)
	
	unique_chars.shuffle()
	hidden_chars_list = unique_chars.slice(0, difficulty_level)
	print("Hidden Letters: ", hidden_chars_list)

func generate_puzzle() -> void:
	# Clear old nodes
	for child in get_children():
		child.queue_free()
	
	var lines = text_content.split("\n")
	
	for line_text in lines:
		var line_row = HBoxContainer.new()
		line_row.add_theme_constant_override("separation", -3) 
		line_row.alignment = BoxContainer.ALIGNMENT_CENTER
		add_child(line_row)
		
		for character in line_text:
			if character == " ":
				var spacer = Control.new()
				spacer.custom_minimum_size.x = 6 
				line_row.add_child(spacer)
			else:
				var slot = letter_slot_scene.instantiate()
				line_row.add_child(slot)
				
				# --- GAME LOGIC ---
				var should_hide = false
				
				# Check if this specific letter is in our "hidden list"
				if character.to_upper() in hidden_chars_list:
					should_hide = true
				
				# We set it up safely
				if slot.has_method("setup"):
					slot.setup(character, should_hide)
					
					if should_hide:
						slot.content_changed.connect(_on_player_typed)
				# ------------------

func _on_player_typed(new_char: String, group_id: String):
	get_tree().call_group(group_id, "external_update", new_char)
	check_victory()

func check_victory():
	var all_correct = true
	
	for row in get_children():
		for slot in row.get_children():
			# Check if it's a slot (has correct_letter var)
			if "correct_letter" in slot:
				# Use get_node to be safe, or direct reference if preferred
				var current_text = slot.get_node("hover/char").text.to_upper()
				if current_text != slot.correct_letter:
					all_correct = false
					break
		if not all_correct: break
	
	if all_correct:
		print("YOU WIN!")
		puzzle_solved.emit()
