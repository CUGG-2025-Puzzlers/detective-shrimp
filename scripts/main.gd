extends Node

# World Roots
@onready var level_root   : Node2D = %LevelRoot
@onready var entity_root  : Node2D = %EntityRoot

# UI Roots
@onready var puzzle_root    : Control = %PuzzleRoot
@onready var hud_root       : Control = %HUDRoot
@onready var transition_root: Control = %TransitionRoot
@onready var pause_root     : Control = %PauseRoot
