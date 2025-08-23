extends CharacterBody2D

var hp = 30
var dead : bool = false	
var time : float = 0.0 
var start_seed = 0
var mag = 0.2
var freq = 15
var max_time_limit = 10000000

var damage = 15

func _ready():
	start_seed = randf()
	time = start_seed * 1000

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
		time += delta * freq
		if(time > max_time_limit):
			time = start_seed
		position.y += sin(time) * mag


func _on_damage_player_body_entered(body):
	if body.name == "Player" and !dead:
		body.hit_player(damage)


func _on_hit_box_body_entered(body):
	if body.name == "Player" and !dead:
		body.boost_up()
		hit_enemy()
