extends Control

func _on_start_button_pressed():
	get_node("/root/main_scene").handle_pause()

func _on_quit_button_pressed():
	get_tree().quit()
