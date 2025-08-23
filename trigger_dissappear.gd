extends StaticBody2D

func dissappear():
	print("trigger breaking!")
	var tween_fade = get_tree().create_tween()
	tween_fade.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 1)
	await tween_fade.finished
	queue_free()
