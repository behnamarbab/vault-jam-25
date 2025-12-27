extends StaticBody2D

@export var current_color: Global.GameColor = Global.GameColor.BLUE
@export var movable: bool = false

var fade_progress: float = 0.0
var is_fading_this_frame: bool = false
var original_position: Vector2
var timer: float = 0.0

@onready var sprite = $Sprite2D

func _ready():
	update_color()
	original_position = position

func _physics_process(delta):
	if movable:
		timer += delta
		position.x = original_position.x + sin(timer * 2.0) * 100.0
	
	if is_fading_this_frame:
		fade_progress += delta
		if fade_progress >= Global.DEFAULT_FADE_TIME:
			fade_out_finished()
		else:
			if sprite:
				var alpha = 1.0 - (fade_progress / Global.DEFAULT_FADE_TIME)
				sprite.modulate.a = alpha
	
	# Reset for next frame
	is_fading_this_frame = false

func get_game_color() -> Global.GameColor:
	return current_color

func update_color():
	if sprite:
		var color_val = Global.get_color_value(current_color)
		var current_alpha = sprite.modulate.a
		sprite.modulate = color_val
		sprite.modulate.a = current_alpha

func mark_for_fading(mover_velocity: Vector2):
	if abs(mover_velocity.x) > 10.0:
		is_fading_this_frame = true

func fade_out_finished():
	print("Platform faded out!")
	queue_free()
