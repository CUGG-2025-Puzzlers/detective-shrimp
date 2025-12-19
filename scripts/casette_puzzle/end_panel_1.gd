extends Panel

signal _panel_enter(panel: Panel)
signal _panel_exit()

func _ready():
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)

func _on_mouse_entered():
	_panel_enter.emit(self)

func _on_mouse_exited():
	_panel_exit.emit()
