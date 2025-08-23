extends Node2D

@onready var player = $Player
@onready var menu = get_node("/root/Game/canvas/Menu")

func _ready():
	menu.visible = false

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		handle_pause()

func handle_pause():
	player.should_pause = !player.should_pause
	menu.visible = player.should_pause
	if menu.visible:
		menu.get_node("VBoxContainer/ResumeButton").grab_focus()


func _on_balloon_body_entered(body):
	if body.name == "Player":
		player.should_pause = true
		print("finished level")
