extends Control
# Main menu


onready var score_display : RichTextLabel = $ScoreDisplay as RichTextLabel


func _ready() -> void:
	($ClearScoreButton as Button).connect("pressed", Scores, "clear_scores")
	Scores.connect("high_scores_cleared", self, "update_high_score_text")

	update_high_score_text()


func on_Button_pressed(mode_name : String) -> void:
	Global.start_new_session(mode_name)


func update_high_score_text() -> void:
	score_display.text = ""

	for mode in Scores.high_scores.keys():
		score_display.text += "\nHigh Score (%s): %d" % [mode, Scores.high_scores[mode]]
