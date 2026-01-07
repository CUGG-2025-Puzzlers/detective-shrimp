extends Node2D

@export var state: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$%Wire.change_state(state)
