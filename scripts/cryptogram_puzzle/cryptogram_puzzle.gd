class_name CryptogramPuzzle
extends Puzzle

const INK_COLOR      : Color = Color(0x521f08ff)
const BANK_USED_COLOR: Color = Color(0x521f0840)
const ALPHABET_LOWER : String = "abcdefghijklmnopqrstuvwxyz"

@export var _data: CryptogramPuzzleData
@export var _max_chars_per_line: int

@onready var _cryptogram: Control = %Cryptogram

var _selected_group: CryptogramGroup = null
var _letter_bank   : Dictionary[String, bool] = {}
var _letter_groups : Dictionary[String, CryptogramGroup] = {}

##################

const CHAR_WIDTH = 8
const CHAR_HEIGHT = 14
const SLOT_BG_COLOR = Color(0.45, 0.3, 0.1, 0.2)
const HIGHLIGHT_COLOR = Color(0.6, 0.35, 0.05, 0.4)

# Maps each unknown target letter to all time its repreated
var letter_groups: Dictionary = {}
# Maps each unknown target letter to all the pannelcontainers
var slot_panels: Dictionary = {}
# Maps panel to target letter
var slot_to_letter: Dictionary = {}
# Maps target letter to what player typed
var player_guesses: Dictionary = {}
# Highligh selected target letter group
var selected_letter: String = ""
var is_active: bool = false

# Letter bank(thing at bottom): maps letter string to on at bottom
var bank_labels: Dictionary = {}

var font: Font
var root_container: VBoxContainer

#region Node Overrides

func _ready():
	GameEvents.group_selected.connect(_on_group_selected)
	GameEvents.bank_letter_clicked.connect(_on_bank_letter_clicked)
	
	_setup()
	
	font = preload("res://fonts/PixelOperator8-Bold.ttf")
	_hide_paper_defaults()
	_build_initial()

func _input(event: InputEvent) -> void:
	if _selected_group == null:
		return
	
	var event_key = event as InputEventKey
	if event_key != null:
		_handle_key_press(event_key)
	
	
	if event is InputEventKey and event.pressed and not event.is_echo():
		var keycode = event.keycode
		if keycode == KEY_ESCAPE:
			selected_letter = ""
			_update_highlights()

#endregion

#region Puzzle Overrides

func get_type() -> GameData.PuzzleType:
	return GameData.PuzzleType.Letter

func start():
	CryptogramPuzzleEvents.start_puzzle()
	_reset_puzzle()

func finish():
	GameData.complete_puzzle(GameData.PuzzleType.Letter)
	CryptogramPuzzleEvents.complete_puzzle()

#endregion

#region Event Handlers

## Event Handler for when a group is selected. 
## Sets the given group as the currently selected group
func _on_group_selected(group: CryptogramGroup) -> void:
	_select_group(group)

## Event Handler for when a letter in the letter bank is clicked. 
## Places the given letter in the currently selected group if there is one. 
func _on_bank_letter_clicked(letter: String) -> void:
	_place_letter(letter)

#endregion

## Sets up the cryptogram
func _setup() -> void:
	_disable_known_letters()
	
	var lines: PackedStringArray = _split_phrase()
	_build_cryptogram(lines)
	
	for line in lines:
		print(line)

## Returns the cryptogram phrase split based on the max characters allowed 
## per line. Words are never split between two lines unless the word length 
## exceeds that threshold.
func _split_phrase() -> PackedStringArray:
	var lines: PackedStringArray = []
	
	var start: int = 0
	while start < len(_data.phrase):
		var line_len: int = _max_chars_per_line
		
		# The rest of the phrase fits on one line
		if line_len >= len(phrase) - index:
			lines.append(phrase.substr(index))
			break
		
		# Phrase too long for one line, break it up
		while line_len > 0 and phrase[index + line_len] != " ":
			line_len -= 1
		
		# Word is longer than one line
		# Take all characters that fit in this line
		if line_len == 0:
			line_len = _max_chars_per_line
		
		lines.append(phrase.substr(index, line_len))
		index += line_len + 1
	
	return lines

## Builds the cryptogram letter by letter, filling in the known letters
func _build_cryptogram(lines: Array[String]) -> void:
	var x: float
	var y: float = 0
	var line_height : float = 20
	var line_width  : float = 8
	for line in lines:
		x = 0
		for c in line:
			# Don't create a slot node for spaces
			if c == " ":
				x += line_width
				continue
			
			var is_letter: bool = c.to_lower() in ALPHABET_LOWER
			var editable: bool = is_letter and (not _letter_bank.has(c) or _letter_bank[c])
			var group: CryptogramGroup = null
			
			# Use existing group
			if _letter_groups.has(c):
				group = _letter_groups[c]
			# Create new group
			elif editable:
				group = CryptogramGroup.new()
				group.expected_letter = c
				_letter_groups[c] = group
			
			# Create new slot
			var slot: CryptogramCharSlot = CryptogramCharSlot.new_slot(editable, group)
			if group != null:
				group.add_slot(slot)
			
			# Position slot
			_cryptogram.add_child(slot)
			slot.set_letter(c if not is_letter or _letter_bank.has(c) else "")
			slot.position = Vector2(x, y)
			
			x += line_width
		
		y += line_height

## Disables the default known letters in the letter bank
func _disable_known_letters() -> void:
	for letter in _data.known_letters:
		_disable_letter(letter)

## Handles a keyboard key press. Letters try to place the letter in the selected 
## group. Backspace/Delete clears the selected group. Escape deselects a group.
func _handle_key_press(event_key: InputEventKey) -> void:
	if event_key == null:
		return
	
	# Only process initial key presses
	if not event_key.pressed or event_key.echo:
		return
	
	var keycode = event_key.keycode
	
	# Attempt to place a letter in the currently selected group
	if keycode >= KEY_A and keycode <= KEY_Z:
		var letter = char(keycode).to_lower()
		if _letter_bank.has(letter) and not _letter_bank[letter]:
			return
		
		_place_letter(letter)
		return
	
	# Clear the currently selected group
	if keycode == KEY_BACKSPACE or keycode == KEY_DELETE:
		_place_letter("")
		return
	
	# Deselect the currently selected group
	if keycode == KEY_ESCAPE:
		_deselect_group()

## Deselects the current group and selects the given group
func _select_group(group: CryptogramGroup) -> void:
	if group == null:
		return
	
	_deselect_group()
	_selected_group = group
	_selected_group.select()

## Deselects the current group
func _deselect_group() -> void:
	if _selected_group == null:
		return
	
	_selected_group.deselect()
	_selected_group = null

## Enables a letter in the letter bank
func _enable_letter(letter: String) -> void:
	_letter_bank[letter] = true
	GameEvents.enable_letter(letter)

## Disables a letter in the letter bank
func _disable_letter(letter: String) -> void:
	_letter_bank[letter] = false
	GameEvents.disable_letter(letter)

## Places the given letter into all the slots in the currently selected group
func _place_letter(letter: String) -> void:
	if _selected_group == null:
		return
	
	var current_letter = _selected_group.current_letter
	if current_letter != "":
		_enable_letter(current_letter)
	
	_selected_group.set_letter(letter)
	if letter != "":
		_disable_letter(letter)
	
	if _selected_group.is_correct():
		_check_for_win()

## Returns true if all letter groups are filled correctly. 
## Returns false otherwise.
func _check_for_win():
	for letter in _letter_groups.keys():
		if not _letter_groups[letter].is_correct():
			return false
	
	return true


# TODO: Remove unneeded code
func _hide_paper_defaults():
	var paper = get_node_or_null("paper")
	if not paper:
		return
	var known_text = paper.get_node_or_null("KnownText")
	if known_text:
		known_text.visible = false
	var letter_slot = paper.get_node_or_null("LetterSlot1")
	if letter_slot:
		letter_slot.visible = false

func _build_initial():
	_clear_all()
	_build_all()

func _reset_puzzle():
	is_active = true
	player_guesses.clear()
	selected_letter = ""
	_clear_all()
	_build_all()

func _clear_all():
	if root_container:
		root_container.queue_free()
		root_container = null
	letter_groups.clear()
	slot_panels.clear()
	slot_to_letter.clear()
	bank_labels.clear()

func _build_all():
	root_container = VBoxContainer.new()
	root_container.position = Vector2(-80, -92)
	root_container.add_theme_constant_override("separation", 3)
	add_child(root_container)

	# Build text grid
	var lines = ""#_wrap_text(PLAINTEXT, CHARS_PER_LINE)
	for line in lines:
		var hbox = HBoxContainer.new()
		hbox.add_theme_constant_override("separation", 0)
		root_container.add_child(hbox)
		for i in line.length():
			_add_char_cell(hbox, line[i])

	# Space text and bank
	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 6)
	root_container.add_child(spacer)

	# Separator line
	var sep = ColorRect.new()
	sep.color = INK_COLOR * Color(1, 1, 1, 0.3)
	#sep.custom_minimum_size = Vector2(CHARS_PER_LINE * CHAR_WIDTH, 1)
	root_container.add_child(sep)

	# Small spacig for the letters
	var spacer2 = Control.new()
	spacer2.custom_minimum_size = Vector2(0, 4)
	root_container.add_child(spacer2)

	_build_letter_bank()

func _build_letter_bank():
	# Show letters that arent known
	var available: Array[String] = []
	for i in range(26):
		var ch = char(97 + i) # a-z
		if ch not in "":#KNOWN_LETTERS:
			available.append(ch)

	# Split the wording to fill the whole papr
	var mid = available.size() / 2
	for row in 2:
		var hbox = HBoxContainer.new()
		hbox.add_theme_constant_override("separation", 1)
		root_container.add_child(hbox)

		var start_idx = row * mid
		var end_idx = mid if row == 0 else available.size()
		for idx in range(start_idx, end_idx):
			var ch = available[idx]
			var label = Label.new()
			label.text = ch
			label.add_theme_font_override("font", font)
			label.add_theme_font_size_override("font_size", 8)
			label.add_theme_color_override("font_color", INK_COLOR)
			label.custom_minimum_size = Vector2(CHAR_WIDTH, 12)
			label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			label.mouse_filter = Control.MOUSE_FILTER_STOP
			label.gui_input.connect(_on_bank_letter_input.bind(ch))
			hbox.add_child(label)
			bank_labels[ch] = label

func _on_bank_letter_input(event: InputEvent, ch: String):
	if not is_active:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if selected_letter == "":
			return
		# Check if letter is already used
		if _is_letter_used(ch):
			return
		_assign_letter(ch)

func _is_letter_used(ch: String) -> bool:
	for target in player_guesses:
		if player_guesses[target] == ch:
			return true
	return false

func _assign_letter(ch: String):
	# Free old letter if group had one
	var old_guess = player_guesses.get(selected_letter, "")

	player_guesses[selected_letter] = ch
	_update_all_slots()
	_update_bank()
	_check_complete()

func _wrap_text(text: String, max_chars: int) -> Array[String]:
	var lines: Array[String] = []
	var words = text.split(" ")
	var current_line = ""

	for word in words:
		if current_line.length() == 0:
			current_line = word
		elif current_line.length() + 1 + word.length() <= max_chars:
			current_line += " " + word
		else:
			lines.append(current_line)
			current_line = word

	if current_line.length() > 0:
		lines.append(current_line)

	return lines

func _is_letter(ch: String) -> bool:
	var lower = ch.to_lower()
	return lower >= "a" and lower <= "z"

func _add_char_cell(parent: HBoxContainer, ch: String):
	var is_known = ch.to_lower() in ""#KNOWN_LETTERS

	if ch == " ":
		var spacer = Control.new()
		spacer.custom_minimum_size = Vector2(CHAR_WIDTH, CHAR_HEIGHT)
		parent.add_child(spacer)
	elif not _is_letter(ch) or is_known:
		# Known letter or punctuation
		var label = Label.new()
		label.text = ch
		label.add_theme_font_override("font", font)
		label.add_theme_font_size_override("font_size", 8)
		label.add_theme_color_override("font_color", INK_COLOR)
		label.custom_minimum_size = Vector2(CHAR_WIDTH, CHAR_HEIGHT)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
		parent.add_child(label)
	else:
		# Unknown letter
		var target = ch.to_lower()

		var panel = PanelContainer.new()
		panel.custom_minimum_size = Vector2(CHAR_WIDTH, CHAR_HEIGHT)
		panel.mouse_filter = Control.MOUSE_FILTER_STOP

		var style = StyleBoxFlat.new()
		style.bg_color = SLOT_BG_COLOR
		style.border_width_bottom = 1
		style.border_color = INK_COLOR * Color(1, 1, 1, 0.6)
		style.content_margin_top = 2
		panel.add_theme_stylebox_override("panel", style)

		var label = Label.new()
		label.text = "_"
		label.add_theme_font_override("font", font)
		label.add_theme_font_size_override("font_size", 8)
		label.add_theme_color_override("font_color", INK_COLOR)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		panel.add_child(label)

		if not letter_groups.has(target):
			letter_groups[target] = []
			slot_panels[target] = []
		letter_groups[target].append(label)
		slot_panels[target].append(panel)
		slot_to_letter[panel] = target

		panel.gui_input.connect(_on_slot_gui_input.bind(target))
		parent.add_child(panel)

func _on_slot_gui_input(event: InputEvent, target: String):
	if not is_active:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_select_letter_group(target)

func _select_letter_group(target: String):
	selected_letter = target
	_update_highlights()

func _update_highlights():
	for letter in slot_panels:
		var panels = slot_panels[letter]
		for panel in panels:
			var style = panel.get_theme_stylebox("panel") as StyleBoxFlat
			if letter == selected_letter:
				style.bg_color = HIGHLIGHT_COLOR
			else:
				style.bg_color = SLOT_BG_COLOR

func _update_all_slots():
	for target in letter_groups:
		var labels = letter_groups[target]
		var guess = player_guesses.get(target, "")
		for label in labels:
			if guess != "":
				label.text = guess
			else:
				label.text = "_"

func _update_bank():
	for ch in bank_labels:
		var label = bank_labels[ch] as Label
		if _is_letter_used(ch):
			label.add_theme_color_override("font_color", BANK_USED_COLOR)
			label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		else:
			label.add_theme_color_override("font_color", INK_COLOR)
			label.mouse_filter = Control.MOUSE_FILTER_STOP

func _check_complete():
	for target in letter_groups:
		var guess = player_guesses.get(target, "")
		if guess != target:
			return
	# Show completed and signal after a delay
	is_active = false
	selected_letter = ""
	# Slots turn green
	var solved_color = Color(0.15, 0.5, 0.15, 0.35)
	for letter in slot_panels:
		for panel in slot_panels[letter]:
			var style = panel.get_theme_stylebox("panel") as StyleBoxFlat
			style.bg_color = solved_color
	# Wait for player to see solved then signal GameEvents to close popup
	await get_tree().create_timer(1.5).timeout
	GameEvents.request_puzzle_complete()
