extends Area2D

var damage = 10


func _on_body_entered(body):
	if body.name == "Player":
		body.hit_player(damage)
