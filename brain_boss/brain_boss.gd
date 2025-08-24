extends CharacterBody2D

@export var hp : int = 100
@export var balloon_damage : int = 10
@export var chase_speed : int = 100
@export var chase_radius_scale : int = 1

@onready var enemy_spawn_point = $Spawn_point

@export var spawn_enemy_cooldown = 7

@onready var timer = $Enemy_spawn_timer

var white_cell_enemy = preload("res://White_blood_cell_enemy/white_blood_cell_enemy.tscn")

var mag = 0.2
var freq = 15
var max_time_limit = 10000000
var player = null
var chase_deadzone = 120

var dead : bool = false
var time = 0
var direction = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/main_scene/Player")
	timer.wait_time = spawn_enemy_cooldown

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !dead:
		time += delta * freq
		if(time > max_time_limit):
			time -= max_time_limit
		position.y += sin(time) * mag
		if global_position.x < player.global_position.x - chase_deadzone:
			$sprite.flip_h = true
			direction = 1
		elif global_position.x > player.global_position.x + chase_deadzone:
			$sprite.flip_h = false
			direction = -1
		else:
			velocity.x = 0
		velocity.x = chase_speed * direction
		move_and_slide()
		
		if timer.is_stopped():
			spawn_enemy()

func spawn_enemy():
	timer.wait_time = spawn_enemy_cooldown
	timer.start()
	var enemy_instance = white_cell_enemy.instantiate()
	enemy_instance.vertical_chase = true
	enemy_instance.get_node("Player_Search_Zone/CollisionShape2D").scale = Vector2(40,40)
	get_parent().add_child(enemy_instance)
	enemy_instance.global_position = enemy_spawn_point.global_position

func hit():
	if !dead:
		hp -= balloon_damage
		var tween_fade = get_tree().create_tween()
		var white_value = 200
		tween_fade.tween_property(self, "modulate", Color(white_value, white_value, white_value, 1.0), 0.05)
		await tween_fade.finished
		tween_fade = get_tree().create_tween()
		tween_fade.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.05)
		await tween_fade.finished
	if hp <= 0:
		dead = true
		var tween_fade = get_tree().create_tween()
		tween_fade.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 1)
		await tween_fade.finished
		get_node(".").queue_free()
		
		get_node("/root/main_scene").win()
