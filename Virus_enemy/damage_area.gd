extends Area2D

func _on_body_entered(body):
	if body.name == "Player":
		print("hit enemy")
		body.boost_up()
		get_node(".").get_parent().hit_enemy()
