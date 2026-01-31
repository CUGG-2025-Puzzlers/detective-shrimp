extends Control

@export var font:Font
@export var font_size: int = 32
@export var letter_slot_scene: PackedScene
@export var max_width: float = 800.0

var text_content = "We often stare so intently at the 
regrets hidden behind the frame that we forget the painting 
of our life is still being created. To find peace, 
one must learn to set down the heavy brush of the past 
and start a fresh sketch on a new canvas."

var paragraph = TextParagraph.new()

func _ready() -> void:
	_generate_text_layout()

func _generate_text_layout() -> void:
	paragraph.clear()
	paragraph.add_string(text_content, font, font_size)
	paragraph.width = max_width
	
	#loop through the calculated layout to spawn buttons
	spawn_buttons_on_glyphs()

func spawn_buttons_on_glyphs() -> void:
	var text_server = TextServerManager.get_primary_interface()
	
	# Start at the top-left of this Control node
	var current_y = 0.0
	
	# Loop through every line of text
	for i in paragraph.get_line_count():
		var line_rid = paragraph.get_line_rid(i)
		var ascent = paragraph.get_line_ascent(i)
		var descent = paragraph.get_line_descent(i)
		var line_height = ascent + descent
		
		# Reset X to 0 for every new line
		var current_x = 0.0
		
		# Get all the visual characters (glyphs) in this line
		var glyphs = text_server.shaped_text_get_glyphs(line_rid)
		
		for glyph in glyphs:
			var advance = glyph.get("advance", 0)
			
			# OPTIONAL: Skip empty spaces so we don't make buttons for whitespace
			# (If the advance is very small, it's likely not a visible character)
			if advance > 0:
				spawn_single_slot(current_x, current_y, advance, line_height)

func spawn_single_slot(x: float, y: float, w: float, h: float) -> void:
	# 1. Create a new instance of your letter_slot scene
	var slot_instance = letter_slot_scene.instantiate()
	
	# 2. Set its position
	slot_instance.position = Vector2(x, y)
	
	# 3. Set its size
	# Note: Your letter_slot root node must be a Control (like Button or MarginContainer)
	slot_instance.custom_minimum_size = Vector2(w, h)
	slot_instance.size = Vector2(w, h) # Force size update immediately
	
	# 4. Add it to the scene
	add_child(slot_instance)

# This draws the actual text behind the buttons so the player can see it
func _draw() -> void:
	paragraph.draw(get_canvas_item(), Vector2.ZERO)

	
