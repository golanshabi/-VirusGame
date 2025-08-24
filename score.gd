extends RichTextLabel

var local = "SCORE: "
var global = "TOTAL: "

func _process(delta: float) -> void:
	var score_text = str(global, str(Globals.total_player_score), "\n", local, str(Globals.player_score))
	self.text = score_text
