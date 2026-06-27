extends Node

# World Roots
@onready var level_root    : Node2D = %LevelRoot
@onready var cut_scene_root: Node2D = %CutSceneRoot

# UI Roots
@onready var puzzle_root: Control = %PuzzleRoot
@onready var transition_root: Control = %TransitionRoot
@onready var pause_root: Control = %PauseRoot
