class_name Wire
extends TextureRect

@export var max_length: int

@onready var wire : WireLine

signal stateChanged;

var state = false
var dragging = false
var hovered_input: GateInput = null

func _ready() -> void:
	# Set WireLine reference to child
	wire = $Wire_Line

