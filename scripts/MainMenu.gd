extends Control

@onready var level_container = $VBoxContainer

func _ready():
	# Clear placeholder buttons if any
	for child in level_container.get_children():
		if child is Button and child.name != "QuitButton":
			child.queue_free()
	
	scan_for_levels()

func scan_for_levels():
	var dir = DirAccess.open("res://levels/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".json"):
				create_level_button(file_name)
			file_name = dir.get_next()

func create_level_button(file_name: String):
	var btn = Button.new()
	# Strip .json for the label
	btn.text = "Play " + file_name.replace(".json", "").capitalize()
	btn.add_theme_font_size_override("font_size", 24)
	
	# Connect using a closure to pass the path
	var path = "res://levels/" + file_name
	btn.pressed.connect(func(): _on_level_selected(path))
	
	# Add before the Quit button
	level_container.add_child(btn)
	level_container.move_child(btn, level_container.get_child_count() - 2)

func _on_level_selected(path: String):
	Global.selected_level_path = path
	get_tree().change_scene_to_file("res://scenes/LevelLoader.tscn")

func _on_quit_pressed():
	get_tree().quit()
