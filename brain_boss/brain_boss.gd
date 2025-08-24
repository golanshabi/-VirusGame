extends CharacterBody2D

@export var hp : int = 100
@export var balloon_damage : int = 10
@export var chase_speed : int = 100
@export var chase_radius_scale : int = 1
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
		$AnimatedSprite2D.play("death")
		await tween_fade.finished
		get_node(".").queue_free()
		
		print("win")
