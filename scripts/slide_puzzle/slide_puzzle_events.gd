extends Node

signal requested_directions(pos: Vector2, directions: Array[Globals.Direction])
signal selected_direction(direction: Globals.Direction)
signal hid_directions()
signal piece_moved()
signal piece_clicked()

func request_directions(pos: Vector2, directions: Array[Globals.Direction]) -> void:
	requested_directions.emit(pos, directions)

func select_direction(direction: Globals.Direction) -> void:
	selected_direction.emit(direction)

func hide_directions() -> void:
	hid_directions.emit()

func move_piece() -> void:
	piece_moved.emit()

func click_piece() -> void:
	piece_clicked.emit()
