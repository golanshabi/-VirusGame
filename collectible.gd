extends Area2D
@onready var sound = preload("res://Assetes/Music/Coin_pickup.wav")

func _on_body_entered(body):
	if body.name == "Player":
		print("player_collec")
		body.increase_score(1, sound)
		queue_free()
