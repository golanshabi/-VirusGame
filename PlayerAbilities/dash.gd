extends Node2D

@onready var timer = $"DashTimer"
@onready var cooldown_timer = $"CooldownTimer"
var ghost_scene = preload("res://PlayerAbilities/ghost.tscn")
@onready var Sprite
var player_sprite

func startDashing(duration, cooldown, sprite):
	timer.wait_time = duration
	cooldown_timer.wait_time = cooldown + duration
	timer.start()
	cooldown_timer.start()
	player_sprite = sprite
	
	instance_ghost()
	
func instance_ghost():
	Sprite = ghost_scene.instantiate()
	get_tree().get_root().add_child(Sprite)	
	
	Sprite.global_position = player_sprite.global_position
	#Sprite.texture = player_sprite.texture
	#Sprite.vframes = player_sprite.vframes
	#Sprite.hframse = player_sprite.hframes
	Sprite.frame = player_sprite.frame
	Sprite.flip_h = player_sprite.flip_h

func is_dashing():
	return !timer.is_stopped()

func is_dash_allowed():
	return cooldown_timer.is_stopped()
