extends RayCast2D

@export var max_length: float = 2000.0
@onready var beam: Line2D = get_parent().get_node("Line2D")

func _ready() -> void:
	enabled = true
	target_position = Vector2.RIGHT * max_length

func _physics_process(_delta: float) -> void:
	force_raycast_update()
	
	var end_point: Vector2 = target_position
	if is_colliding():
		end_point = to_local(get_collision_point())
	
	beam.clear_points()
	beam.add_point(Vector2.ZERO)
	beam.add_point(end_point)
