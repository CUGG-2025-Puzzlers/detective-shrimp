extends Control

var alphabet := "abcdefghijklmnopqrstuvwxyz"
var mapping := {}

func _ready():
	mapping = generate_random_mapping()

	print("\n=== RANDOM ALPHABET MAPPING ===")
	for letter in alphabet:
		print(letter, " → ", mapping[letter])

	run_tests()


func generate_random_mapping():
	# Convert PackedStringArray → Array so shuffle() works
	var letters: Array = alphabet.split("") 
	var shuffled: Array = alphabet.split("")
	shuffled.shuffle()

	var map := {}
	for i in range(letters.size()):
		map[letters[i]] = shuffled[i]

	return map


func encode_text(text: String) -> String:
	var result := ""
	text = text.to_lower()

	for c in text:
		if mapping.has(c):
			result += mapping[c]
		else:
			result += c
	return result


func run_tests():
	print("\n=== TESTING RANDOM CIPHER ===")

	var test_inputs = [
		"Nothing is so painful to the human mind as a great and sudden change. The sun might shine or the clouds might lower, but nothing could appear to me as it had done the day before. "
	]

	for word in test_inputs:
		var encoded = encode_text(word)
		print("Original:  ", word)
		print("Encoded:   ", encoded)
		print("---")

	print("=== END OF TEST ===\n")
