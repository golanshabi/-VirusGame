extends Node2D

@onready var turret = $"../Turret/Spawner"
@onready var slab = $"../BreakingSlab3"
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_children().size() == 0:
		turret.set_stop()
		slab.dissappear()
		queue_free()
