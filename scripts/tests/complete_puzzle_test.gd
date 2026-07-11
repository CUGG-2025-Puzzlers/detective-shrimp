extends Button

@export var puzzle_type: GameData.PuzzleType

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed():
	GameEvents.request_puzzle_complete()
