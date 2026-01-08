@tool
extends Node2D

@export var state: bool : set = set_state

#region Editor Functions

func set_state(value: bool):
	if value == state:
		return
	
	$%Wire.change_state(value)
	state = value

#endregion

func _ready() -> void:
	$%Wire.change_state(state)
