extends CharacterBody2D

const SPEED = 110.0

@export var animation_tree : AnimationTree
@export var animation_player : AnimationPlayer
@export var stairs_tilemap : TileMapLayer

var input : Vector2
var canMove : bool 
var playback : AnimationNodeStateMachinePlayback

func _ready():
	visible = false
	canMove = true
	
	playback = animation_tree["parameters/playback"]
	Globals.requested_player_hide.connect(_on_requested_player_hide)
	Globals.requested_player_show.connect(_on_requested_player_show)
	GameEvents.dialogue_started.connect(_on_dialogue_started)
	GameEvents.dialogue_ended.connect(_on_dialogue_ended)
	GameEvents.puzzle_started.connect(_on_puzzle_started)
	GameEvents.puzzle_finished.connect(_on_puzzle_finished)
	GameEvents.puzzle_exited.connect(_on_puzzle_exited)

func _physics_process(delta: float) -> void:
	if not visible or not canMove:
		return
	
	input = Input.get_vector("left", "right", "up", "down")
	
	velocity = input.normalized() * SPEED * delta
 
	move_and_collide(velocity)
	select_animation()
	update_animation_parameters()

func select_animation():
	if velocity == Vector2.ZERO:
		playback.travel("Idle")
	else:
		playback.travel("Walk")

func update_animation_parameters():
	if input == Vector2.ZERO:
		return
		
	animation_tree["parameters/Walk/blend_position"] = input
	animation_tree["parameters/Idle/blend_position"] = input

func _on_requested_player_hide():
	visible = false

func _on_requested_player_show(pos: Vector2):
	global_position = pos
	visible = true

func _on_dialogue_started(dialogue: Dialogue):
	pause_movement()

func _on_dialogue_ended(name: String):
	resume_movement()

func _on_puzzle_started(trigger: GameEvents.PuzzleTrigger):
	pause_movement()

func _on_puzzle_finished(trigger: GameEvents.PuzzleTrigger):
	resume_movement()

func _on_puzzle_exited(trigger: GameEvents.PuzzleTrigger):
	resume_movement()

func pause_movement():
	velocity = Vector2.ZERO
	select_animation()
	canMove = false

func resume_movement():
	canMove = true
