extends CharacterBody2D
const SPEED = 300
const DAMAGE = 20

func _on_body_entered(body):
	if body.name == "Player":
		print("Player spiked")
		body.hit_player(DAMAGE)
		queue_free()


func _process(delta: float) -> void:
	velocity.x = SPEED
	move_and_slide()
