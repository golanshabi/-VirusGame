extends CheckBox

func _on_toggled(toggled_on):
	get_node("/root/main_scene/canvas/HUD/blood_particles").emitting = toggled_on
