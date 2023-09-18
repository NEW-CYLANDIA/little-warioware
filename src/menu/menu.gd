extends Control
# Main menu

onready var score_display: RichTextLabel = $ScoreDisplay


func _ready() -> void:
	$ClearScoreButton.connect("pressed", Scores, "clear_scores")
	Scores.connect("high_scores_cleared", self, "update_high_score_text")

	update_high_score_text()


func update_high_score_text() -> void:
	score_display.text = ""

	for mode in Scores.high_scores.keys():
		score_display.text += "\nHigh Score (%s): %d" % [mode, Scores.high_scores[mode]]
