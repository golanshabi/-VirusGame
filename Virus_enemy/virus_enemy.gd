extends CharacterBody2D

var hp = 20
var dead : bool = false	

func hit_enemy():
	if !dead:
		hp -= 10
	
	if hp <= 0:
		dead = true
		#play death animation
		get_node(".").queue_free()
	
