extends CharacterBody2D

var hp = 10
var dead : bool = false	
var time : float = 0.0 
var start_seed = 0
var mag = 0.2
var freq = 15
var max_time_limit = 10000000

var is_rolling : bool = false
var in_roll_animation : bool = false
var ROLL_COOLDOWN = 7
var roll_speed = 150
var roll_angular_speed = 0.5
var direction = 1

var get_into_roll_animation = "get_into_roll"
var get_out_of_roll_animation = "get_out_of_roll"

@onready var roll_timer = $RollCoolDownTimer
var damage = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	is_rolling = false
	in_roll_animation = false
	$AnimatedSprite2D.rotation = 0
	roll_timer.wait_time = ROLL_COOLDOWN
	$AnimatedSprite2D.play("idle")
	$PhysicalCollider_circle.disabled = true
	$PhysicalCollider_pill.disabled = false
	randomize()
	#var start_seed = floor(randf()*3000)
	#print(start_seed)
	#await get_tree().create_timer(start_seed).timeout
	start_roll_countdown()

func hit_enemy():
	if !dead:
		hp -= 10
		var tween_fade = get_tree().create_tween()
		var white_value = 200
		tween_fade.tween_property(self, "modulate", Color(white_value, white_value, white_value, 1.0), 0.05)
		await tween_fade.finished
		tween_fade = get_tree().create_tween()
		tween_fade.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.05)
		await tween_fade.finished
	if hp <= 0:
		dead = true
		$PhysicalCollider_circle.disabled = true
		$PhysicalCollider_pill.disabled = true
		var tween_fade = get_tree().create_tween()
		tween_fade.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 2.5)
		$AnimatedSprite2D.play("death")
		await tween_fade.finished
		get_node(".").queue_free()
	
func _physics_process(delta):
	if !dead:
		if not is_on_floor():
			var gravity = get_gravity() * delta
			velocity += gravity
		
		if in_roll_animation:
			$hitbox/CollisionShape2D.disabled = true
			$damage_player/PillCollider.scale.x = 2
			velocity.x = roll_speed * direction
			$AnimatedSprite2D.rotate(roll_angular_speed * direction)
		else:
			$hitbox/CollisionShape2D.disabled = false
			$damage_player/PillCollider.scale.x = 1.0
		if !is_rolling and roll_timer.is_stopped():
			roll()
		move_and_slide()

func _on_damage_player_body_entered(body):
	if body.name == "Player" and !dead:
		body.hit_player(damage)

func _on_hitbox_body_entered(body):
	if body.name == "Player" and !dead:
		body.boost_up()
		hit_enemy()

func roll():
	is_rolling = true
	roll_timer.wait_time = ROLL_COOLDOWN
	$AnimatedSprite2D.play(get_into_roll_animation)
	await 	get_tree().create_timer(0.75).timeout
	$PhysicalCollider_circle.disabled = false
	$PhysicalCollider_pill.disabled = true
	in_roll_animation = true
	velocity.x = roll_speed * direction

func start_roll_countdown():
	roll_timer.start()

func stop_rolling():
	is_rolling = false
	in_roll_animation = false
	direction *= -1
	$AnimatedSprite2D.flip_h = !$AnimatedSprite2D.flip_h
	$AnimatedSprite2D.rotation = 0
	roll_timer.wait_time = ROLL_COOLDOWN
	$AnimatedSprite2D.play(get_out_of_roll_animation)
	start_roll_countdown()
	await 	get_tree().create_timer(0.75).timeout
	$PhysicalCollider_circle.disabled = true
	$PhysicalCollider_pill.disabled = false
	$AnimatedSprite2D.play("idle")

func _on_check_terrain_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.name == "TileMap" or body.name == "TileMap2":
		stop_rolling()
