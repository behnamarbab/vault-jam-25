extends Area2D

@export var fade_time: float = Global.DEFAULT_FADE_TIME # Time to fully recover

var player_inside: Node2D = null

@onready var sprite = $Sprite2D

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	# Set a low alpha for the recovery area so it stays distinct but transparent
	if sprite:
		sprite.modulate.a = 0.3

func _physics_process(delta):
	if player_inside and player_inside.has_method("recover_fade"):
		# If it takes X seconds to fade out, it should take Y seconds to recover
		# Passing delta / fade_time as the recovery amount
		player_inside.recover_fade(delta / fade_time)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_inside = body

func _on_body_exited(body):
	if body == player_inside:
		player_inside = null
