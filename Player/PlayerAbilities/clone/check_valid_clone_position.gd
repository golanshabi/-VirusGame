extends Area2D

var cloning_allowed : bool = true;
	
	
func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.name != "clone" and body.name !="":
		print(body.name)
		cloning_allowed = false
