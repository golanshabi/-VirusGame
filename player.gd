extends CharacterBody2D


const SPEED = 200.0
const DASH_SPEED = 350
const gravity_mult = 1.2
const JUMP_SINGLE_VELOCITY = -325.0
const GRAVITY_REDUCTION_RATIO = 0.6
const DASH_COOLDOWN_SEC = 0.2

const CLONE_DURATION = 1.5
const CLONE_COOLDOWN = 2
const CLONE_RADIUS = 30

# State variables
var dash_duration = 0.2
var hp = 100

var knockback_force : float = 0.0
var max_knockback_force : float = 400
var knockback_divider = 10
var is_in_knockback : bool = false
var dead : bool = false

@onready var dash = $Dash
@onready var cloner = $cloner
var last_direction = 1
var jump_state : JumpState = JumpState.FLOOR

enum JumpState {
	TRANS_JUMP,
	JUMP,
	TRANS_FLOOR,
	FLOOR
}

func _physics_process(delta: float) -> void:
	if dead:
		print("dead")
		return

	if (jump_state == JumpState.FLOOR && !is_on_floor()):
		jump_state = JumpState.TRANS_JUMP
	elif (jump_state == JumpState.JUMP && is_on_floor()):
		jump_state = JumpState.TRANS_FLOOR

	if Input.is_action_just_pressed("dash") and dash.is_dash_allowed() and Input.get_axis("ui_left", "ui_right") and !is_in_knockback:
		dash.startDashing(dash_duration, DASH_COOLDOWN_SEC, $AnimatedSprite2D, !is_on_floor())

	if jump_state == JumpState.TRANS_FLOOR:
		dash.set_stop_flying()
	# Add the gravity.
	if not is_on_floor():
		var gravity = get_gravity() * delta * gravity_mult
		if velocity.y < 0 and Input.is_action_pressed("ui_accept"):
			gravity = gravity * GRAVITY_REDUCTION_RATIO
		velocity += gravity

	if Input.is_action_just_pressed("jump") and is_on_floor() and !is_in_knockback:
		velocity.y = JUMP_SINGLE_VELOCITY
	
	#var clone_dir : Vector2 = get_global_mouse_position() - global_position
	var vec : Vector2 = global_position + Vector2.DOWN * CLONE_RADIUS
	$clone_aim.global_position = vec
	
	if Input.is_action_pressed("clone_aim") and cloner.is_clone_allowed() and !is_in_knockback and !is_on_floor():
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
	trans_state()
	move_and_slide()

func boost_up():
	velocity.y = JUMP_SINGLE_VELOCITY

func apply_knockback():
	is_in_knockback = true
	knockback_force = max_knockback_force

func hit_player(damage : int):
	hp -= damage
	apply_knockback()
	if hp <= 0:
		dead = true
	else:
		var tween_fade = get_tree().create_tween()
		var white_value = 200
		tween_fade.tween_property(self, "modulate", Color(white_value, white_value, white_value, 1.0), 0.05)
		await tween_fade.finished
		tween_fade = get_tree().create_tween()
		tween_fade.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.05)
func trans_state():
	if jump_state == JumpState.TRANS_FLOOR || jump_state == JumpState.TRANS_JUMP:
		jump_state += 1
