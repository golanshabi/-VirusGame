extends Node2D
var bullet = preload("res://Turret/bullet.tscn")
@onready var cooldown_timer = $"../CoolDownTimer"
const TIME_PER_SHOT = 1
var stop = false

func _process(delta: float) -> void:
	if cooldown_timer.is_stopped() && not stop:
		cooldown_timer.wait_time = TIME_PER_SHOT
		cooldown_timer.start()
		var bullet_instance = bullet.instantiate()
		get_parent().add_child(bullet_instance)
		bullet_instance.global_position = global_position

func set_stop():
	stop = true
