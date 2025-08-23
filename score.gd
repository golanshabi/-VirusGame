extends RichTextLabel

var PREFIX = "SCORE: "

func _process(delta: float) -> void:
	var score_text = str(PREFIX, str(Globals.player_score))
	self.text = score_text
