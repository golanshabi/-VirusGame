extends Node2D

@onready var timer = $"DashTimer"
@onready var cooldown_timer = $"CooldownTimer"
var ghost_scene = preload("res://PlayerAbilities/dash/ghost.tscn")
@onready var Sprite
var player_sprite
var is_flying

func startDashing(duration, cooldown, sprite, is_fly):
	timer.wait_time = duration
	cooldown_timer.wait_time = cooldown + duration
	timer.start()
	cooldown_timer.start()
	player_sprite = sprite
	is_flying = is_fly
	
	instance_ghost()
	
func instance_ghost():
	Sprite = ghost_scene.instantiate()
	get_tree().get_root().add_child(Sprite)	
	
	Sprite.global_position = player_sprite.global_position
	Sprite.frame = player_sprite.frame
	Sprite.flip_h = player_sprite.flip_h

func is_dashing():
	return !timer.is_stopped()

func is_dash_allowed():
	return cooldown_timer.is_stopped() && !is_flying

func set_stop_flying():
	is_flying = false
