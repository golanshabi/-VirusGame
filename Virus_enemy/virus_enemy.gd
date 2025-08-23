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
	
	if hp <= 0:
		dead = true
		#play death animation
		get_node(".").queue_free()
	
func _process(delta):
	time += delta * freq
	if(time > max_time_limit):
		time = start_seed
	position.y += sin(time) * mag
