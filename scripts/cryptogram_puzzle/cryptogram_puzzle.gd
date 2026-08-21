class_name CryptogramPuzzle
extends Puzzle

const BASE_COLOR   : Color = Color(0x521f08ff)
const SUCCESS_COLOR: Color = Color(0x26802659)

@export var _data: CryptogramPuzzleData
@export var _label_settings: LabelSettings
@export var _max_chars_per_line: int

@onready var _cryptogram: Control = %Cryptogram

var _selected_group: CryptogramGroup = null
var _letter_bank  : Dictionary[String, bool] = {}
var _letter_groups: Dictionary[String, CryptogramGroup] = {}

#region Node Overrides

func _ready():
	super._ready()
	GameEvents.group_selected.connect(_on_group_selected)
	GameEvents.bank_letter_clicked.connect(_on_bank_letter_clicked)
	
	_setup()

func _input(event: InputEvent) -> void:
	if _selected_group == null:
		return
	
	var event_key = event as InputEventKey
	if event_key != null:
		_handle_key_press(event_key)

#endregion

#region Puzzle Overrides

func get_type() -> GameData.PuzzleType:
	return GameData.PuzzleType.Letter

func start():
	for c in _letter_groups.keys():
		_letter_groups[c].enable()

func finish():
	_deselect_group()
	for c in _letter_groups.keys():
		_letter_groups[c].disable()
	
	_label_settings.font_color = SUCCESS_COLOR

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
	_label_settings.font_color = BASE_COLOR
	_disable_known_letters()
	
	var lines: PackedStringArray = _split_phrase()
	_build_cryptogram(lines)

## Returns the cryptogram phrase split based on the max characters allowed 
## per line. Words are never split between two lines unless the word length 
## exceeds that threshold.
func _split_phrase() -> PackedStringArray:
	var lines: PackedStringArray = []
	
	var index: int = 0
	var phrase = _data.phrase.to_lower()
	while index < len(phrase):
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
			
			var is_letter: bool = c >= 'a' and c <= 'z'
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
func _check_for_win() -> void:
	for letter in _letter_groups.keys():
		if not _letter_groups[letter].is_correct():
			return
	
	GameEvents.request_puzzle_complete()
