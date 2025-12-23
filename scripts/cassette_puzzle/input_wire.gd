extends Node2D

@export var state: bool

@onready var wire: Wire

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wire = $Wire
	wire.change_state(state)
