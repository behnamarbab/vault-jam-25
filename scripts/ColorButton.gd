extends Area2D

@export var target_color: Global.GameColor = Global.GameColor.GREEN

@onready var sprite = $Sprite2D

func _ready():
	update_button_visuals()
	body_entered.connect(_on_body_entered)

func update_button_visuals():
	if sprite:
		sprite.modulate = Global.get_color_value(target_color)

func _on_body_entered(body):
	if body.has_method("set_color"):
		# Version 0.0.7: Universal color button
		body.set_color(target_color)
		print("Color changed to: ", target_color)
