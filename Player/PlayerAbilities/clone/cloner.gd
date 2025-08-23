extends Node

@onready var cooldown_timer = $"CooldownTimer"

var clone = preload("res://Player/PlayerAbilities/clone/clone.tscn")
@onready var Sprite
var global_position

func do_clone(cooldown, dest_pos):
	#check_position_area.position = position
	#print(check_position_area.cloning_allowed)
	#if !check_position_area.cloning_allowed:
		#check_position_area.cloning_allowed = true
		#return
	cooldown_timer.wait_time = cooldown
	cooldown_timer.start()
	global_position = dest_pos
	
	instance_clone()
	
func instance_clone():
	Sprite = clone.instantiate()
	get_tree().get_root().add_child(Sprite)	
	
	Sprite.global_position = global_position
	#Sprite.frame = player_sprite.frame
	#Sprite.flip_h = player_sprite.flip_h

func is_clone_allowed():
	return cooldown_timer.is_stopped() 
