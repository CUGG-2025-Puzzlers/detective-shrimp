class_name LightBendingPuzzle
extends Puzzle

@onready var start_light_button: Button = %StartLightButton
@onready var light_source: Light = %LightSource
@onready var background_layer: TileMapLayer = %LightPuzzleBackground
@onready var object_layer: TileMapLayer = %LightPuzzleObjects

const PLACEABILITY_LAYER = 0

func _ready() -> void:
	start_light_button.pressed.connect(_on_start_pressed)

func start() -> void:
	var raycast = $LightSource/RayCast2D
	raycast.restart()
	for shrimp in get_tree().get_nodes_in_group("color_shrimp"):
		if shrimp.has_method("deactivate"):
			shrimp.deactivate()
	var letter = get_tree().get_first_node_in_group("target")
	if letter:
		letter.victory_triggered = false
	GameEvents.attempted_reflector_placement.connect(_on_attempted_reflector_placement)
	

func finish() -> void:
	print("Light puzzle complete!")
	GameEvents.reflection_complete = true
	
	GameEvents.attempted_reflector_placement.disconnect(_on_attempted_reflector_placement)

func _on_start_pressed() -> void:
	light_source.fire()

func _on_attempted_reflector_placement(reflector: Reflector, pos: Vector2) -> void:
	var cell_coords: Vector2 = background_layer.local_to_map(pos)
	var background_tile_data: TileData = background_layer.get_cell_tile_data(cell_coords)
	var object_tile_data: TileData = object_layer.get_cell_tile_data(cell_coords)
	
	# Put the reflector back to where it was if trying to 
	# place out of bounds or on another puzzle object
	if not background_tile_data or object_tile_data:
		reflector.put_back()
		return
	
	# Check the background layer for placeability
	var can_place: bool = background_tile_data.get_custom_data_by_layer_id(PLACEABILITY_LAYER)
	if can_place:
		reflector.place()
		return
	
	reflector.put_back()
