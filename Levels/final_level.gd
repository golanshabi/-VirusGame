extends Node2D

@onready var player = get_node("/root/main_scene/Player")
@onready var spawn_point = $SpawnPoint
# Called when the node enters the scene tree for the first time.

var should_respawn = true

func _ready():
	player.position = spawn_point.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.dead and should_respawn:
		respawn_player()

func respawn_player():
	should_respawn = false
	player.should_pause = true
	await get_tree().create_timer(player.respawn_time).timeout
	player.position = spawn_point.position
	await get_tree().create_timer(0.1).timeout
	player.respawn(true)
	player.should_pause = false
	player.dead = false
	should_respawn = true

func _on_balloon_body_entered(body):
	pass
	#launch balloon

func finish_level():
	player.should_pause = true
	player.finish_level_mask.visible = true
	for i in 100:
	#finish_level_balloon.velocity.y = -200
		await get_tree().create_timer(0.01).timeout
		player.position.y -= 1
		player.finish_level_mask.scale *= 0.9835
	player.reset_level_mask()
	get_node("/root/main_scene").progress_level()
	player.should_pause = false
