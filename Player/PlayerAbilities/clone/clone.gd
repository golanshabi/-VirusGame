extends Node2D


func _ready():
	ghosting()

func set_property(tx_pos, tx_scale):
	position = tx_pos
	scale = tx_scale
	
func ghosting():
	var tween_fade = get_tree().create_tween()
	
	tween_fade.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 1.5)
	
	await tween_fade.finished
	
	queue_free()
