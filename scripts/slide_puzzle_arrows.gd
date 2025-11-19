class_name DirectionalArrows
extends Control

func show_arrows(directions: Array[Globals.Direction]) -> void:
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
	$LeftArrow.hide()
	$RightArrow.hide()
	$UpArrow.hide()
	$DownArrow.hide()
