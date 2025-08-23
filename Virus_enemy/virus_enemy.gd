extends CharacterBody2D

var hp = 20
var dead : bool = false	
var time : float = 0.0 
var start_seed = 0
var mag = 0.2
var freq = 15
var max_time_limit = 10000000

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
	if hp <= 0:
		dead = true
		#play death animation
		get_node(".").queue_free()
	
func _process(delta):
	time += delta * freq
	if(time > max_time_limit):
		time = start_seed
	position.y += sin(time) * mag
