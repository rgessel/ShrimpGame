extends Control

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/start_screen.tscn")
