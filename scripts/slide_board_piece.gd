class_name SlideBoardPiece
extends TextureRect

@export var piece_type: PieceType

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

enum PieceType {
	OneByOne,
	OneByTwo,
	TwoByOne,
	TwoByTwo,
}
