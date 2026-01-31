class_name SafePuzzle
extends Puzzle

@export var combination: Array[int] = [2, 1, 6, 7]

@onready var digit_1: LineEdit = $%Digit1
@onready var digit_2: LineEdit = $%Digit2
@onready var digit_3: LineEdit = $%Digit3
@onready var digit_4: LineEdit = $%Digit4
@onready var submit_button: Button = $%SubmitButton
@onready var feedback_label: Label = $%FeedbackLabel

var digits: Array[LineEdit]

func _ready() -> void:
	digits = [digit_1, digit_2, digit_3, digit_4]
	submit_button.pressed.connect(_on_submit)

	for i in range(digits.size()):
		var digit = digits[i]
		digit.max_length = 1
		# Automatically move to the next box when number is in
		digit.text_changed.connect(_on_digit_typed.bind(i))

func start() -> void:
	SafePuzzleEvents.start_puzzle()
	_reset()

func finish() -> void:
	print("Safe unlocked!")
	SafePuzzleEvents.complete_puzzle()

func _reset() -> void:
	for digit in digits:
		digit.text = ""
		digit.editable = true
	feedback_label.text = ""
	digit_1.grab_focus()

func _on_digit_typed(new_text: String, index: int) -> void:
	# Numbers only
	if new_text.length() > 0 and not new_text.is_valid_int():
		digits[index].text = ""
		return
	# Move to next digit when filled
	if new_text.length() == 1 and index < digits.size() - 1:
		digits[index + 1].grab_focus()

func _on_submit() -> void:
	# Check if all digits filled
	for digit in digits:
		if digit.text.length() == 0:
			_show_feedback("Enter all 4 digits")
			return

	# Check combination
	var entered: Array[int] = []
	for digit in digits:
		entered.append(int(digit.text))

	if entered == combination:
		# Win
		for digit in digits:
			digit.editable = false
		feedback_label.text = "Unlocked!"
		feedback_label.modulate = Color(0.2, 1.0, 0.2)
		GameEvents.finish_puzzle(GameEvents.PuzzleTrigger.PuzzleSafe)
	else:
		#Lose
		_show_feedback("Wrong combination")
		_shake()

func _show_feedback(text: String) -> void:
	feedback_label.text = text
	feedback_label.modulate = Color(1.0, 0.3, 0.3)

func _shake() -> void:
	var original_pos = position
	var tween = create_tween()
	tween.tween_property(self, "position", original_pos + Vector2(4, 0), 0.05)
	tween.tween_property(self, "position", original_pos - Vector2(4, 0), 0.05)
	tween.tween_property(self, "position", original_pos + Vector2(2, 0), 0.05)
	tween.tween_property(self, "position", original_pos, 0.05)
