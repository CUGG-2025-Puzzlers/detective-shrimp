class_name LightPuzzleObjectLayer
extends TileMapLayer

class ActivationData:
	var tile_pos: Vector2i
	var activation_id: int
	
	func _init(pos: Vector2i, id: int) -> void:
		tile_pos = pos
		activation_id = id

@onready var _activators: Array[ActivationData]
@onready var _activables: Array[ActivationData]

var _active_tiles: Array[ActivationData]
var reset: bool = false

func _ready() -> void:
	_setup_puzzle_objects()
	GameEvents.activated_activator.connect(_on_activated_activator)
	GameEvents.beam_fired.connect(_on_beam_fired)

func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	# Mark all activators and activables for reset
	if reset:
		return _is_tile_in_array(coords, _activators) or _is_tile_in_array(coords, _activables)
	
	# Mark active tiles for transparency
	return _is_tile_in_array(coords, _active_tiles)

func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData) -> void:
	# Reset all activators and activables
	if reset:
		tile_data.modulate.a = 1.0
		return
	
	# Make active tile transparent
	tile_data.modulate.a = 0.25

# Returns true if the tile at the given coordinates is exists in the given array
# Returns false otherwise
func _is_tile_in_array(coords: Vector2i, arr: Array[ActivationData]) -> bool:
	for tile in arr:
		if tile.tile_pos == coords:
			return true
	
	return false

# Sets up the internal lists holding activators and activables
func _setup_puzzle_objects() -> void:
	var used_cells: Array[Vector2i] = get_used_cells()
	
	for cell in used_cells:
		var data: LightPuzzleTileData = LightPuzzleTileData.new(self, cell)
		if not data.valid:
			print("Used cell (%d, %d) has invalid data" % [cell.x, cell.y])
			continue
		
		var activation_data: ActivationData = ActivationData.new(cell, data.activation_id)
		
		if data.is_activator:
			_activators.append(activation_data)
			continue
		
		if data.is_activable:
			_activables.append(activation_data)
			continue

# Event handler for when an activator has been hit
# Hides the activator completely and makes the corresponding activables transparent
func _on_activated_activator(coords: Vector2i, id: int) -> void:
	reset = false
	var activator: ActivationData
	for a in _activators:
		if a.tile_pos == coords and a.activation_id == id:
			activator = a
			break
	
	if not activator:
		print("No activator with ID %d found at (%d, %d)" % [id, coords.x, coords.y])
		return
	
	_active_tiles.append(activator)
	for a in _activables:
		if a.activation_id == id:
			_active_tiles.append(a)
	
	notify_runtime_tile_data_update()

# Event handler for when the light beam is fired
# Clears the active tiles and sets them to opaque
func _on_beam_fired() -> void:
	_active_tiles.clear()
	reset = true
	notify_runtime_tile_data_update()
