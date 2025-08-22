extends CharacterBody2D


const SPEED = 200.0
const DASH_SPEED = 275
const JUMP_SINGLE_VELOCITY = -300.0
const GRAVITY_REDUCTION_RATIO = 0.65
const DASH_COOLDOWN_SEC = 2.5

const CLONE_DURATION = 3
const CLONE_COOLDOWN = 3
# State variables
var dash_duration = 0.2
var hp = 100

var knockback_force : int = 0
var max_knockback_force : int = 400
var knockback_divider = 10
var is_in_knockback : bool = false
var dead : bool = false

@onready var dash = $Dash
@onready var cloner = $cloner
var last_direction = 1

func _physics_process(delta: float) -> void:
	if dead:
		print("dead")
		return
		
	if Input.is_action_just_pressed("dash") and dash.is_dash_allowed() and Input.get_axis("ui_left", "ui_right") and !is_in_knockback:
		dash.startDashing(dash_duration, DASH_COOLDOWN_SEC, $AnimatedSprite2D)
	# Add the gravity.
	if not is_on_floor():
		var gravity = get_gravity() * delta
		if velocity.y < 0 and Input.is_action_pressed("ui_accept"):
			gravity = gravity * GRAVITY_REDUCTION_RATIO
		velocity += gravity
	
		

	if Input.is_action_just_pressed("jump") and is_on_floor() and !is_in_knockback:
		velocity.y = JUMP_SINGLE_VELOCITY
	
	if Input.is_action_pressed("clone_aim") and cloner.is_clone_allowed() and !is_in_knockback:
		var vec : Vector2 = get_global_mouse_position()
		cloner.do_clone(CLONE_COOLDOWN, vec)
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	last_direction = direction if direction != 0 else last_direction
	
	if !is_in_knockback:
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
	else:
		velocity.x = knockback_force * last_direction * -1
		knockback_force -= max_knockback_force/knockback_divider
		if knockback_force <= 0:
			knockback_force = 0
			is_in_knockback = false
	move_and_slide()

func boost_up():
	velocity.y = JUMP_SINGLE_VELOCITY

func apply_knockback():
	is_in_knockback = true
	knockback_force = max_knockback_force

func hit_player(damage : int):
	print("hit")
	hp -= damage
	apply_knockback()
	if hp <= 0:
		dead = true
