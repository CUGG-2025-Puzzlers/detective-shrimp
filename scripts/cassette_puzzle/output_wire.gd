class_name OutputWire
extends Node

@export var wire: Line2D
var game_settings: GameSettings = preload("res://resources/game_settings.tres")

signal state_changed(new_state: bool)
var state: bool = false

# Listen for underlying Gate Input state changes
func _ready() -> void:
	$%WireConnection.state_changed.connect(_on_state_changed)

# Emit a signal whenever the state is toggled between true or false values
# Null is treated as false when using ==
func _on_state_changed():
	var new_state: bool
	if $%WireConnection.wire == null:
		set_color(null)
		new_state = false
	else:
		set_color($%WireConnection.wire.state)
		new_state = $%WireConnection.wire.state == true
	
	if new_state == state:
		return
	
	state = new_state
	state_changed.emit(state)

func set_color(new_state):
	if new_state == null:
		wire.self_modulate = game_settings.null_color
	elif new_state:
		wire.self_modulate = game_settings.on_color
	else:
		wire.self_modulate = game_settings.off_color
