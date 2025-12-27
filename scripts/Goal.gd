extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player":
		print("Goal reached! You win!")
		# Restart level or show message
		get_tree().reload_current_scene()
