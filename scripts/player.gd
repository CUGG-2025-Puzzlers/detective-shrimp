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
	playback = animation_tree["parameters/playback"]
	Globals.requested_player_hide.connect(_on_requested_player_hide)
	Globals.requested_player_show.connect(_on_requested_player_show)
	GameEvents.dialogue_started.connect(_on_dialogue_started)
	GameEvents.dialogue_ended.connect(_on_dialogue_ended)

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

func _on_requested_player_show():
	visible = true

func _on_dialogue_started(dialogue: Dialogue):
	canMove = false

func _on_dialogue_ended():
	canMove = true
