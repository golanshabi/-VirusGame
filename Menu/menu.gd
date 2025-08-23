extends Control

func _on_start_button_pressed():
	get_node("/root/Game").handle_pause()

func _on_options_button_pressed():
	pass # Replace with function body.


func _on_quit_button_pressed():
	get_tree().quit()
