extends Area2D

var vel_up = 0
var hit_already = false
var ascend_enabled = true
var time = 0
var max_time = 6

# Called when the node enters the scene tree for the first time.
func _ready():
	initialize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ascend_enabled:
		position.y += vel_up * delta
	if vel_up != 0:
		if time >= max_time:
			hit_already = true
			ascend_enabled = false
		else:
			time += delta


func _on_body_entered(body):
	if body.name == "Player":
		vel_up = -100
	elif body.name == "brain_boss" and !hit_already:
		hit_already = true
		body.hit()
		ascend_enabled = false
		var tween_fade = get_tree().create_tween()
		tween_fade.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 1.5)
		await tween_fade.finished

func initialize():
	var tween_fade = get_tree().create_tween()
	tween_fade.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.3)
	await tween_fade.finished
	vel_up = 0
	time = 0
	hit_already = false
	ascend_enabled = true
