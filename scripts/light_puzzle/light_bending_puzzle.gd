class_name LightBendingPuzzle
extends Puzzle

@onready var start_light_button: Button = %StartLightButton
@onready var light_source: Light = %LightSource
@onready var background_layer: TileMapLayer = %LightPuzzleBackground
@onready var object_layer: TileMapLayer = %LightPuzzleObjects
@onready var reflectors: Node2D = %Reflectors

var _reflectors: Array[Reflector]

const PLACEABILITY_LAYER = 0

func _ready() -> void:
	super._ready()
	start_light_button.pressed.connect(_on_start_pressed)
	
	_setup_reflectors()

func get_type() -> GameData.PuzzleType:
	return GameData.PuzzleType.Light

func start() -> void:
	GameEvents.attempted_reflector_placement.connect(_on_attempted_reflector_placement)
	GameEvents.beam_finished.connect(_on_beam_finished)

func finish() -> void:
	print("Light puzzle complete!")
	GameEvents.attempted_reflector_placement.disconnect(_on_attempted_reflector_placement)

# Event listener for when the start button is pressed
# Fires the light beam, disables the start button
func _on_start_pressed() -> void:
	GameEvents.fire_beam()
	start_light_button.disabled = true
	light_source.fire()

# Event listener for when the light beam finished animating
# Re-enables the start button
func _on_beam_finished(hit_target: bool) -> void:
	start_light_button.disabled = hit_target

# Event listener for when attempting to place a reflector on a tile
# Returns the reflector back to its pick up position if placed in an invalid tile
# Leaves it where it was dropped otherwise
func _on_attempted_reflector_placement(reflector: Reflector, pos: Vector2) -> void:
	var cell_coords: Vector2 = background_layer.local_to_map(pos)
	var background_tile_data: TileData = background_layer.get_cell_tile_data(cell_coords)
	var object_tile_data: TileData = object_layer.get_cell_tile_data(cell_coords)
	
	# Out of bounds
	if not background_tile_data:
		print("Cannot place reflector out of bounds")
		reflector.put_back()
		return
	
	# On another puzzle object
	if object_tile_data:
		print("Cannot place reflector on other puzzle object")
		reflector.put_back()
		return
	
	# On another reflector
	if is_tile_occupied(reflector):
		print("Cannot place reflector on another reflector")
		reflector.put_back()
		return
	
	# On a wall (or other non-placeable tile in the background layer)
	var can_place: bool = background_tile_data.get_custom_data_by_layer_id(PLACEABILITY_LAYER)
	if not can_place:
		print("Cannot place reflector on wall")
		reflector.put_back()
		return

# Sets up the reference list of reflectors in the puzzle
func _setup_reflectors() -> void:
	_reflectors.clear()
	for r in reflectors.get_children():
		if r is not Reflector:
			continue
		
		_reflectors.append(r)

# Returns true if a reflector already occupies the given reflector's position
# Returns false otherwise
func is_tile_occupied(reflector: Reflector) -> bool:
	for r in _reflectors:
		if r == reflector:
			continue
		
		if r.position == reflector.position:
			return true
	
	return false
