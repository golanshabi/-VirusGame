extends CharacterBody2D

var dead : bool = false	
var time : float = 0.0 
var start_seed = 0
var mag = 0.2
var freq = 15
var max_time_limit = 10000000

@export var flip_h : bool = false
@export var chase_speed : int = 100
@export var chase_radius_scale : int = 1
@export var hp : int = 30
@export var damage = 15

@onready var siren = $Siren

var player
var chasing : bool = false
var chase_deadzone = 30
var direction = 1

func _ready():
	if flip_h:
		$AnimatedSprite2D.flip_h = true
		direction = -1
	start_seed = randf()
	time = start_seed * 1000
	$Player_Search_Zone.scale.x = chase_radius_scale

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
		$PhysicalCollider.disabled = true
		var tween_fade = get_tree().create_tween()
		tween_fade.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 1)
		$AnimatedSprite2D.play("death")
		await tween_fade.finished
		get_node(".").queue_free()
	
func _process(delta):
	if !dead:
		if not is_on_floor():
			var gravity = get_gravity() * delta
			velocity += gravity
			
		time += delta * freq
		if(time > max_time_limit):
			time = start_seed
		position.y += sin(time) * mag
		if chasing and player != null:
			siren.visible = true
			if global_position.x < player.global_position.x - chase_deadzone:
				$AnimatedSprite2D.flip_h = false
				direction = 1
			elif global_position.x > player.global_position.x + chase_deadzone:
				$AnimatedSprite2D.flip_h = true
				direction = -1
			velocity.x = chase_speed * direction
		else:
			siren.visible = false
			velocity.x = 0
		move_and_slide()
	else:
		$AudioStreamPlayer2D.playing = false



func _on_damage_player_body_entered(body):
	if body.name == "Player" and !dead:
		body.hit_player(damage)


func _on_hit_box_body_entered(body):
	if body.name == "Player" and !dead:
		body.boost_up()
		hit_enemy()

func _on_player_search_zone_body_entered(body):
	if body.name == "Player":
		player = body
		freq *= 1.5
		chasing = true
		$AudioStreamPlayer2D.playing = true
		$AnimatedSprite2D.play("chase")

func _on_player_search_zone_body_exited(body):
	if body.name == "Player":
		player = null
		freq /= 1.5
		chasing = false
		$AudioStreamPlayer2D.playing = false
		$AnimatedSprite2D.play("idle")
		
