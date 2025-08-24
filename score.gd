extends RichTextLabel

var local = "SCORE: "
var global = "TOTAL: "

func _process(delta: float) -> void:
	var manager = get_parent().get_parent().get_parent();
	var score_text = str(global, str(manager.total_player_score), "\n", local, str(manager.player_score))
	self.text = score_text
