extends Node2D

@onready var player = $Player
@onready var menu = get_node("/root/main_scene/canvas/Menu")
@onready var levels_container = $LevelsContainer

var player_score = 0
var total_player_score = 0

var level_index = 0

@onready var levels = []

func _ready():
	menu.visible = false
	levels.append(preload("res://Levels/final_level.tscn"))
	levels.append(preload("res://Levels/first_level.tscn"))
	levels.append(preload("res://Levels/second_level.tscn"))
	levels.append(preload("res://Levels/third_level.tscn"))
	levels.append(preload("res://Levels/4_th_level.tscn"))

	progress_level()

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		handle_pause()

func handle_pause():
	player.should_pause = !player.should_pause
	menu.visible = player.should_pause
	if menu.visible:
		menu.get_node("VBoxContainer/ResumeButton").grab_focus()

func progress_level():
	if level_index < levels.size():
		if levels_container.get_child(0):
			levels_container.get_child(0).queue_free()
		var lvl = levels[level_index].instantiate()
		player.respawn()
		levels_container.add_child(lvl)
		level_index += 1
		if  levels_container.get_child(0).name == "Final_level":
			$Player/Camera2D.zoom = Vector2(1.6, 1.6)
		else:
			$Player/Camera2D.zoom = Vector2(2.2, 2.2)

func reload_level():
	if levels_container.get_child(0):
		levels_container.get_child(0).queue_free()
	var lvl = levels[level_index - 1].instantiate()
	levels_container.add_child(lvl)
