extends Node

@onready var timer = $"DashTimer"
@onready var cooldown_timer = $"CooldownTimer"

var clone = preload("res://PlayerAbilities/clone/clone.tscn")
@onready var Sprite
var global_position

func do_clone(cooldown, position):

	cooldown_timer.wait_time = cooldown
	cooldown_timer.start()
	global_position = position
	
	instance_clone()
	
func instance_clone():
	Sprite = clone.instantiate()
	get_tree().get_root().add_child(Sprite)	
	
	Sprite.global_position = global_position
	#Sprite.frame = player_sprite.frame
	#Sprite.flip_h = player_sprite.flip_h

func is_clone_allowed():
	return cooldown_timer.is_stopped()
