extends Node

signal puzzle_started()
signal puzzle_completed()
signal board_clicked()
signal directions_requested(pos: Vector2, directions: Array[Globals.Direction])
signal directions_selected(direction: Globals.Direction)
signal directions_hidden()
signal piece_moved()
signal piece_clicked()

func start_puzzle() -> void:
	puzzle_started.emit()

func complete_puzzle() -> void:
	puzzle_completed.emit()

func click_board() -> void:
	board_clicked.emit()

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
