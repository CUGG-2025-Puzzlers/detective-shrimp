extends Node2D




func _on_resume_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_level.tscn")
	
	
	


func _on_quit_pressed() -> void:
	get_tree().quit()
