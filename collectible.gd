extends Area2D

func _on_body_entered(body):
	if body.name == "Player":
		print("player_collec")
		body.increase_score(1)
		queue_free()
