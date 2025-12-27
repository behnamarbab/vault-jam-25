extends Control

func _on_level_1_pressed():
	Global.selected_level_path = "res://levels/level1.json"
	get_tree().change_scene_to_file("res://scenes/LevelLoader.tscn")

func _on_quit_pressed():
	get_tree().quit()
