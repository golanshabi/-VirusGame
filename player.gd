extends CharacterBody2D


const SPEED = 100.0
const DASH_SPEED = 275
const JUMP_SINGLE_VELOCITY = -275.0
const GRAVITY_REDUCTION_RATIO = 0.70
const DASH_COOLDOWN_SEC = 2.5
# State variables
var dash_duration = 0.2

@onready var dash = $Dash

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("dash") and dash.is_dash_allowed():
		dash.startDashing(dash_duration, DASH_COOLDOWN_SEC, $AnimatedSprite2D)
	# Add the gravity.
	if not is_on_floor():
		var gravity = get_gravity() * delta
		if velocity.y < 0 and Input.is_action_pressed("ui_accept"):
			gravity = gravity * GRAVITY_REDUCTION_RATIO
		velocity += gravity
	
		

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_SINGLE_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	var speed = SPEED
	var animation = "move"
	if dash.is_dashing():
		speed = DASH_SPEED
		velocity.y = 0
		animation = "dash"
	if Input.is_action_pressed("ui_right"):
		$AnimatedSprite2D.play(animation)
		velocity.x = speed
		$AnimatedSprite2D.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		$AnimatedSprite2D.play(animation)
		velocity.x = -speed
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.play("idle")
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
