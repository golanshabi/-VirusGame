extends Node2D

var balloon : Area2D
@onready var respawn_timer = $respawn_timer

@export var respawn_cooldown : int = 5
var started_timer = false

func _ready():
	if get_child(1):
		balloon = get_child(1)
	balloon.global_position = global_position
	respawn_timer.wait_time = respawn_cooldown
	started_timer = false

func _process(delta):
	if !balloon:
		return
	
	if balloon.hit_already and !started_timer:
		started_timer = true
		respawn_timer.start()
	
	if respawn_timer.time_left == 0 and started_timer:
		spawn_balloon()

func spawn_balloon():
	balloon.initialize()
	balloon.global_position = global_position
	respawn_timer.stop()
	respawn_timer.wait_time = respawn_cooldown
	started_timer = false
