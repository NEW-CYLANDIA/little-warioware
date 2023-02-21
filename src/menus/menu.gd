extends Control
# Main menu


onready var score_display : RichTextLabel = $ScoreDisplay as RichTextLabel


func _ready() -> void:
	($ClearScoreButton as Button).connect("pressed", Global, "_clear_scores")
	Global.connect("high_scores_cleared", self, "update_high_score_text")

	update_high_score_text()


func on_Button_pressed(mode_name : String) -> void:
	Global.start_new_session(mode_name)
	get_tree().change_scene("res://src/play_session/intermission.tscn")


func update_high_score_text() -> void:
	score_display.text = ""

	for mode in Global.high_scores.keys():
		score_display.text += "\nHigh Score (%s): %d" % [mode, Global.high_scores[mode]]
