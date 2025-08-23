extends StaticBody2D

func _on_body_entered(body):
	if body.name == "Player":
		print("slab breaking!")
		var tween_fade = get_tree().create_tween()
		tween_fade.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 1)
		await tween_fade.finished
		queue_free()
