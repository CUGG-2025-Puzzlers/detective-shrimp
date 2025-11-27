class_name DirectionalArrows
extends Control

var shown

func _ready() -> void:
	SlidePuzzleEvents.directions_requested.connect(on_requested_directions)
	SlidePuzzleEvents.directions_selected.connect(on_selected_direction)
	SlidePuzzleEvents.directions_hidden.connect(hide_arrows)
	SlidePuzzleEvents.piece_clicked.connect(hide_arrows)
	SlidePuzzleEvents.board_clicked.connect(hide_arrows)
	hide_arrows()

func on_requested_directions(pos: Vector2, directions: Array[Globals.Direction]):
	position = pos + Vector2(4, 4)
	show_arrows(directions)

func on_selected_direction(direction: Globals.Direction):
	hide_arrows()

func show_arrows(directions: Array[Globals.Direction]) -> void:
	shown = true
	for direction in directions:
		match direction:
			Globals.Direction.Left:
				$LeftArrow.show()
			Globals.Direction.Right:
				$RightArrow.show()
			Globals.Direction.Up:
				$UpArrow.show()
			Globals.Direction.Down:
				$DownArrow.show()

func hide_arrows() -> void:
	shown = false
	$LeftArrow.hide()
	$RightArrow.hide()
	$UpArrow.hide()
	$DownArrow.hide()
