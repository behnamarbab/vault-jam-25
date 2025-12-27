extends StaticBody2D

@export var target_color: Global.GameColor = Global.GameColor.GREEN

@onready var sprite = $Sprite2D
@onready var detection_area = $DetectionArea

func _ready():
	if sprite:
		sprite.modulate = Global.get_color_value(target_color)
	if detection_area:
		detection_area.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.has_method("set_color"):
		body.set_color(target_color)
		print("Color changed to: ", target_color)
