extends Node2D

@export var grid_size: int = 16
@export var grid_color: Color = Color(1, 1, 1, 0.15)
@export var grid_width: Vector2 = Vector2(640, 360)

func _draw() -> void:
	# Draw vertical lines
	for x in range(0, int(grid_width.x) + 1, grid_size):
		draw_line(Vector2(x, 0), Vector2(x, grid_width.y), grid_color, 1.0)

	# Draw horizontal lines
	for y in range(0, int(grid_width.y) + 1, grid_size):
		draw_line(Vector2(0, y), Vector2(grid_width.x, y), grid_color, 1.0)
