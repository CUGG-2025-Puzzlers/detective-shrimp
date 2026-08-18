class_name CryptogramGroup

var slots: Array[CryptogramCharSlot]
var current_letter: String
var expected_letter: String

func add_slot(slot: CryptogramCharSlot) -> void:
	slots.append(slot)

func set_letter(letter: String) -> void:
	current_letter = letter
	for slot in slots:
		slot.set_letter(letter)

func select() -> void:
	for slot in slots:
		slot.select()

func deselect() -> void:
	for slot in slots:
		slot.deselect()

func is_correct() -> bool:
	return current_letter == expected_letter
