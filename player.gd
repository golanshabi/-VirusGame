extends CharacterBody2D

var should_pause : bool = false

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


@onready var audio_player = $AudioStreamPlayer2D
@onready var HUD = get_node("/root/main_scene/canvas/HUD")
@onready var HP_bar = get_node("/root/main_scene/canvas/HUD/HP_bar")
@onready var Dash_cd_bar = get_node("/root/main_scene/canvas/HUD/Dash_cd")
@onready var Clone_cd_bar = get_node("/root/main_scene/canvas/HUD/Clone_cd")

var enemy_hit_sound_array = []
var player_hit_sound_array = []

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

func _ready():
	player_hit_sound_array.append(preload("res://Assetes/Music/hit_effect_1.wav"))
	player_hit_sound_array.append(preload("res://Assetes/Music/hit_effect_2.wav"))
	enemy_hit_sound_array.append(preload("res://Assetes/Music/enemy_hit_1.wav"))
	enemy_hit_sound_array.append(preload("res://Assetes/Music/enemy_hit_2.wav"))
	
	HP_bar.max_value = hp
	HP_bar.value = hp
	
	Dash_cd_bar.max_value = DASH_COOLDOWN_SEC
	Dash_cd_bar.value = DASH_COOLDOWN_SEC
	
	Clone_cd_bar.max_value = CLONE_COOLDOWN
	Clone_cd_bar.value = CLONE_COOLDOWN

func _physics_process(delta: float) -> void:
	if dead:
		return

	if (jump_state == JumpState.FLOOR && !is_on_floor()):
		jump_state = JumpState.TRANS_JUMP
	elif (jump_state == JumpState.JUMP && is_on_floor()):
		jump_state = JumpState.TRANS_FLOOR

	Dash_cd_bar.value = DASH_COOLDOWN_SEC - dash.cooldown_timer.time_left
	Clone_cd_bar.value = CLONE_COOLDOWN - cloner.cooldown_timer.time_left
	
	if Input.is_action_just_pressed("dash") and dash.is_dash_allowed() and Input.get_axis("ui_left", "ui_right") and is_not_input_restricted():
		dash.startDashing(dash_duration, DASH_COOLDOWN_SEC, $AnimatedSprite2D, !is_on_floor())
		$Dash_effect.emitting = true

	if jump_state == JumpState.TRANS_FLOOR:
		dash.set_stop_flying()
	# Add the gravity.
	if not is_on_floor() and !should_pause:
		var gravity = get_gravity() * delta * gravity_mult
		if velocity.y < 0 and Input.is_action_pressed("ui_accept"):
			gravity = gravity * GRAVITY_REDUCTION_RATIO
		velocity += gravity

	if Input.is_action_just_pressed("jump") and is_on_floor() and is_not_input_restricted():
		velocity.y = JUMP_SINGLE_VELOCITY
	
	#var clone_dir : Vector2 = get_global_mouse_position() - global_position
	var vec : Vector2 = global_position + Vector2.DOWN * CLONE_RADIUS
	$clone_aim.global_position = vec
	
	if Input.is_action_pressed("clone_aim") and cloner.is_clone_allowed() and is_not_input_restricted() and !is_on_floor():
		cloner.do_clone(CLONE_COOLDOWN, vec)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	last_direction = direction if direction != 0 else last_direction
	
	if is_not_input_restricted():
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
	if !should_pause:
		trans_state()
		move_and_slide()

func is_not_input_restricted():
	return !is_in_knockback and !should_pause

func boost_up():
	play_random_hit_sound(enemy_hit_sound_array)
	$Hit_effect/CPUParticles2D.emitting = true
	velocity.y = JUMP_SINGLE_VELOCITY

func apply_knockback():
	is_in_knockback = true
	knockback_force = max_knockback_force

func hit_player(damage : int):
	play_random_hit_sound(player_hit_sound_array)
	hp -= damage
	if hp <= 0:
		hp = 0
		dead = true
		$AnimatedSprite2D.play("death")
	else:
		apply_knockback()
		var tween_fade = get_tree().create_tween()
		var white_value = 200
		tween_fade.tween_property(self, "modulate", Color(white_value, white_value, white_value, 1.0), 0.05)
		await tween_fade.finished
		tween_fade = get_tree().create_tween()
		tween_fade.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.05)
	HP_bar.value = hp

func trans_state():
	if jump_state == JumpState.TRANS_FLOOR || jump_state == JumpState.TRANS_JUMP:
		jump_state += 1

func increase_score(added_score):
	Globals.player_score += added_score
	print(Globals.player_score)

func get_score():
	return Globals.player_score

func play_random_hit_sound(array):
	var random_index = randi() % array.size()
	audio_player.stream = array[random_index]
	audio_player.play()
