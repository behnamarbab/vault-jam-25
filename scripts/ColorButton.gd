extends Area2D

enum ButtonType {CHANGE, RESET}
@export var button_type: ButtonType = ButtonType.CHANGE
@export var target_color: Global.GameColor = Global.GameColor.GREEN # Only used if we want specific color buttons, but task says "as intended"

@onready var sprite = $Sprite2D

func _ready():
	update_button_visuals()
	body_entered.connect(_on_body_entered)

func update_button_visuals():
	if sprite:
		if button_type == ButtonType.RESET:
			sprite.modulate = Color.WHITE
		else:
			sprite.modulate = Global.get_color_value(target_color)

func _on_body_entered(body):
	if body.has_method("set_color"):
		if button_type == ButtonType.RESET:
			body.set_color(Global.GameColor.PURPLE)
			print("Color reset to PURPLE")
		else:
			# Version 0.0.6: Direct color change
			body.set_color(target_color)
			print("Color changed to: ", target_color)
