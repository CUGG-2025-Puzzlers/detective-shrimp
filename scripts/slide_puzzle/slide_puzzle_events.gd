extends Node

signal directions_requested(pos: Vector2, directions: Array[Globals.Direction])
signal directions_selected(direction: Globals.Direction)
signal directions_hidden()
signal piece_moved()
signal piece_clicked()

func request_directions(pos: Vector2, directions: Array[Globals.Direction]) -> void:
	directions_requested.emit(pos, directions)

func select_direction(direction: Globals.Direction) -> void:
	directions_selected.emit(direction)

func hide_directions() -> void:
	directions_hidden.emit()

func move_piece() -> void:
	piece_moved.emit()

func click_piece() -> void:
	piece_clicked.emit()
