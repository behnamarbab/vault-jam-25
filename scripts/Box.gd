extends CharacterBody2D

@export var current_color: Global.GameColor = Global.GameColor.RED
@export var fade_time: float = Global.DEFAULT_FADE_TIME

var fade_progress: float = 0.0
var is_fading_this_frame: bool = false
var push_strength: float = 0.0

@onready var sprite = $Sprite2D

func _ready():
	update_color()

func get_game_color() -> Global.GameColor:
	return current_color

func _physics_process(delta):
	# Box specific movement: Pushed by player
	# We rely on the player script calling move_and_slide on us
	# Reset velocity each frame to prevent sliding after push ends
	velocity.x = 0
	move_and_slide()
	
	if is_fading_this_frame:
		fade_progress += delta
		if fade_progress >= fade_time:
			fade_out_finished()
		else:
			if sprite:
				var alpha = 1.0 - (fade_progress / fade_time)
				sprite.modulate.a = alpha
	
	# Reset for frame
	is_fading_this_frame = false

func update_color():
	if sprite:
		var color_val = Global.get_color_value(current_color)
		# Preserve current alpha
		var current_alpha = sprite.modulate.a
		sprite.modulate = color_val
		sprite.modulate.a = current_alpha

func set_color(new_color: Global.GameColor):
	current_color = new_color
	update_color()

func mark_for_fading(mover_velocity: Vector2):
	# Only fade if there is horizontal movement (interaction)
	if abs(mover_velocity.x) > 10.0:
		is_fading_this_frame = true

func fade_out_finished():
	print("Box faded out!")
	queue_free()
