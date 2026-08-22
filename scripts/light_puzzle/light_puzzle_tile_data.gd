class_name LightPuzzleTileData

const NULL_TILE: Vector2i = Vector2i(-1, -1)

# Tilset Custom Data Layers
const TILE_DATA_TARGET: String = "is_target"
const TILE_DATA_ACTIVATOR: String = "is_activator"
const TILE_DATA_ACTIVABLE: String = "is_activable"
const TILE_DATA_ACTIVATION_ID: String = "activation_id"

var valid: bool = false
var is_target: bool
var is_activator: bool
var is_activable: bool
var activation_id: int

func _init(map: TileMapLayer, coords: Vector2i) -> void:
	var source_id: int = map.get_cell_source_id(coords)
	var atlas_coords: Vector2i = map.get_cell_atlas_coords(coords)
	var alt_id: int = map.get_cell_alternative_tile(coords)
	var source: TileSetAtlasSource = map.tile_set.get_source(source_id)
	print("Tile world coordinates: (%d, %d)" % [coords.x, coords.y])
	print("Tile atlas coordinates: (%d, %d)" % [atlas_coords.x, atlas_coords.y])
	
	# Unexpected collision: No tile found at collision position
	if atlas_coords == NULL_TILE:
		print("Failed to retrieve tile from atlas")
		valid = false
		return
	
	# Get tile data
	var data: TileData = source.get_tile_data(atlas_coords, alt_id)
	
	if data == null:
		print("Failed to retrieve tile data")
		valid = false
		return
	
	# Set tile data
	valid = true
	is_target = data.get_custom_data(TILE_DATA_TARGET) as bool
	is_activator = data.get_custom_data(TILE_DATA_ACTIVATOR) as bool
	is_activable = data.get_custom_data(TILE_DATA_ACTIVABLE) as bool
	activation_id = data.get_custom_data(TILE_DATA_ACTIVATION_ID) as int
