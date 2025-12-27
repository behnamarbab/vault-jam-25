extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -566.0

@export var current_color: Global.GameColor = Global.GameColor.PURPLE

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var fade_progress: float = 0.0
var is_fading_this_frame: bool = false

@onready var sprite = $Sprite2D

func _ready():
	update_color()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	# Reset fading flag before checking collisions
	is_fading_this_frame = false
	
	# Check for collisions for color mechanic
	check_color_collisions()
	
	# Process fading
	if is_fading_this_frame:
		fade_progress += delta
		if fade_progress >= Global.DEFAULT_FADE_TIME:
			fade_out_finished()
		else:
			# Update alpha based on progress
			if sprite:
				var alpha = 1.0 - (fade_progress / Global.DEFAULT_FADE_TIME)
				sprite.modulate.a = alpha

func update_color():
	if sprite:
		var color_val = Global.get_color_value(current_color)
		# Preserve current alpha if we are fading
		var current_alpha = sprite.modulate.a
		sprite.modulate = color_val
		sprite.modulate.a = current_alpha

func set_color(new_color: Global.GameColor):
	current_color = new_color
	update_color()

func check_color_collisions():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider.has_method("get_game_color"):
			var other_color = collider.get_game_color()
			handle_color_interaction(other_color, collider)

func handle_color_interaction(other_color: Global.GameColor, collider: Object):
	var my_order = Global.get_color_order(current_color)
	var other_order = Global.get_color_order(other_color)
	
	if other_order > my_order:
		is_fading_this_frame = true
	elif my_order > other_order:
		if collider.has_method("mark_for_fading"):
			collider.mark_for_fading()

func fade_out_finished():
	print("Player faded out!")
	# Reset position and color
	position = Vector2(100, 100) # Assuming start position
	set_color(Global.GameColor.PURPLE)
	fade_progress = 0.0
	if sprite:
		sprite.modulate.a = 1.0
