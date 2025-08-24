extends CharacterBody2D
const SPEED = 250
const DAMAGE = 20

func _on_body_entered(body):
	if body.name == "Player":
		body.hit_player(DAMAGE)
		queue_free()
	if body.name == "clone" or body.name == "TileMap2":
		queue_free()


func _process(delta: float) -> void:
	velocity.x = SPEED
	move_and_slide()
