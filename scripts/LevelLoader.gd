extends Node2D

const TILE_SIZE = 64

@export var level_path: String = "res://levels/level1.json"

@onready var player_scene = preload("res://scenes/Player.tscn")
@onready var platform_scene = preload("res://scenes/Platform.tscn")
@onready var goal_scene = preload("res://scenes/Goal.tscn")
@onready var button_scene = preload("res://scenes/ColorButton.tscn")

enum ObjectID {
	EMPTY = 0,
	PLATFORM_YELLOW = 1,
	PLATFORM_GREEN = 2,
	PLATFORM_BLUE = 3,
	PLAYER = 4,
	GOAL = 5,
	BUTTON_GREEN = 6,
	BUTTON_RESET = 7
}

func _ready():
	load_level(Global.selected_level_path)

func load_level(path: String):
	if not FileAccess.file_exists(path):
		print("Level file not found: ", path)
		return
		
	var json_as_text = FileAccess.get_file_as_string(path)
	var json = JSON.parse_string(json_as_text)
	
	if json == null:
		print("Failed to parse level JSON")
		return
		
	var objects = json.get("objects", [])
	for obj_data in objects:
		var type = obj_data.get("type", "")
		var grid_pos = obj_data.get("position", [0, 0])
		var props = obj_data.get("properties", {})
		
		spawn_object_v2(type, grid_pos, props)

func spawn_object_v2(type: String, grid_pos: Array, props: Dictionary):
	var pos = Vector2(grid_pos[0] * TILE_SIZE, grid_pos[1] * TILE_SIZE)
	var scene = null
	var instance_props = {}
	
	match type:
		"player":
			scene = player_scene
			if props.has("color"):
				instance_props["current_color"] = Global.get_color_from_name(props["color"])
		"platform", "obstacles":
			scene = platform_scene
			if props.has("color"):
				instance_props["current_color"] = Global.get_color_from_name(props["color"])
			if props.has("movable"):
				instance_props["movable"] = props["movable"]
		"goal":
			scene = goal_scene
		"button":
			scene = button_scene
			if props.has("color"):
				instance_props["target_color"] = Global.get_color_from_name(props["color"])
			# Default behavior for buttons in JSON: direct color change
			instance_props["button_type"] = 0
			if props.has("is_reset") and props["is_reset"]:
				instance_props["button_type"] = 1

	if scene:
		var instance = create_instance(scene, pos, instance_props)
		
		# Apply scaling
		var length = props.get("length", 1.0)
		var height = props.get("height", 1.0)
		instance.scale = Vector2(length, height)

func create_instance(scene: PackedScene, pos: Vector2, properties: Dictionary = {}):
	var instance = scene.instantiate()
	add_child(instance)
	instance.position = pos
	
	for prop in properties:
		if prop in instance:
			instance.set(prop, properties[prop])
	
	return instance
