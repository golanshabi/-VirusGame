extends Control
	
func _on_start_button_pressed():
	get_node("/root/main_scene").handle_pause()

func _on_quit_button_pressed():
	get_tree().quit()
	
func _on_reset_button_pressed():
	get_node("/root/main_scene").handle_pause()
	var main = get_node("/root/main_scene/")
	main.levels_container.get_child(0).respawn_player(false)
