extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -566.0

@export var current_color: Global.GameColor = Global.GameColor.PURPLE
@export var fade_time: float = Global.DEFAULT_FADE_TIME

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
	
	# Death check: Falling
	if position.y > 5000:
		die()

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
	
	# Version 0.0.9: Fade when not on a platform
	if not is_on_floor():
		is_fading_this_frame = true
	
	# Check for collisions for color mechanic
	check_color_collisions()
	
	# Process fading
	# Ground: Fade based on horizontal movement
	# Air: Fade based on vertical movement
	var movement_trigger = false
	if is_on_floor():
		movement_trigger = abs(velocity.x) > 10.0
	else:
		movement_trigger = abs(velocity.y) > 10.0

	if is_fading_this_frame and movement_trigger:
		fade_progress += delta
		if fade_progress >= fade_time:
			fade_out_finished()
		else:
			# Update alpha based on progress
			if sprite:
				var alpha = 1.0 - (fade_progress / fade_time)
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
		
		# Death check: Enemy group
		if collider.is_in_group("enemy"):
			die()
			return

		# Pushing logic for boxes: Only if pushing from the side
		if collider.is_in_group("pushable") and collider is CharacterBody2D:
			var normal = collision.get_normal()
			# Normal points towards the player. 
			# If it's horizontal (abs(x) > 0.9), it's a side push.
			if abs(normal.x) > 0.9:
				collider.velocity.x = velocity.x * 0.5
				collider.move_and_slide()

		if collider.has_method("get_game_color"):
			var other_color = collider.get_game_color()
			handle_color_interaction(other_color, collider)
		elif "current_color" in collider:
			# Fallback for objects that might not have the method but have the property
			handle_color_interaction(collider.current_color, collider)

func handle_color_interaction(other_color: Global.GameColor, collider: Object):
	# Version 0.0.5 Logic:
	# Same color -> Higher order logic replaced by pure match
	# If same color, other object fades
	if current_color == other_color:
		if collider.has_method("mark_for_fading"):
			collider.mark_for_fading(velocity)
	# If different color, player fades
	else:
		is_fading_this_frame = true

func die():
	print("Player died!")
	get_tree().reload_current_scene()

func fade_out_finished():
	print("Player faded out!")
	die()
