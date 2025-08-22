extends Node2D

@onready var timer = $"DashTimer"
@onready var cooldown_timer = $"CooldownTimer"

func startDashing(duration, cooldown):
	timer.wait_time = duration
	cooldown_timer.wait_time = cooldown + duration
	timer.start()
	cooldown_timer.start()

func is_dashing():
	return !timer.is_stopped()

func is_dash_allowed():
	return cooldown_timer.is_stopped()
