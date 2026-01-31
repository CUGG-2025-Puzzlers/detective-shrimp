extends Area2D

const GRID_SIZE: int = 16

var dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO
var last_valid_position: Vector2

@onready var sprite: Sprite2D = $reflector

func _ready() -> void:
	set_process_input(true)
	add_to_group("reflector")
	# Snap to grid on start and store as last valid position
	last_valid_position = snap_to_grid(global_position)
	global_position = last_valid_position

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var mouse_global: Vector2 = get_global_mouse_position()
			var mouse_local: Vector2 = to_local(mouse_global)

			if sprite.get_rect().has_point(mouse_local):
				dragging = true
				drag_offset = global_position - mouse_global
		else:
			if dragging:
				# On release, snap to grid and validate
				var snapped_pos = snap_to_grid(get_global_mouse_position() + drag_offset)
				if is_valid_position(snapped_pos):
					global_position = snapped_pos
					last_valid_position = snapped_pos
				else:
					# Invalid position, return to last valid
					global_position = last_valid_position
			dragging = false

	elif event is InputEventMouseMotion and dragging:
		# Follow mouse while dragging (visual feedback)
		global_position = get_global_mouse_position() + drag_offset

func snap_to_grid(pos: Vector2) -> Vector2:
	# Snap to center of grid cell
	var grid_x = floor(pos.x / GRID_SIZE) * GRID_SIZE + GRID_SIZE / 2.0
	var grid_y = floor(pos.y / GRID_SIZE) * GRID_SIZE + GRID_SIZE / 2.0
	return Vector2(grid_x, grid_y)

func is_valid_position(pos: Vector2) -> bool:
	# Check for walls in tilemap
	var tilemap_layer = get_tree().get_first_node_in_group("wall")
	if tilemap_layer and tilemap_layer is TileMapLayer:
		# Convert global position to tilemap's local coordinates
		var local_pos = tilemap_layer.to_local(pos)
		var cell_coords = tilemap_layer.local_to_map(local_pos)
		var tile_data = tilemap_layer.get_cell_tile_data(cell_coords)
		if tile_data != null:
			# There's a wall tile here
			return false

	# Check for other reflectors at this position
	for reflector in get_tree().get_nodes_in_group("reflector"):
		if reflector == self:
			continue
		var other_snapped = snap_to_grid(reflector.global_position)
		if other_snapped == pos:
			return false

	return true
