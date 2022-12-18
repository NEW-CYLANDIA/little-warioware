extends Control
# Main menu


func _ready():
	# warning-ignore:return_value_discarded
	$Button3.connect("pressed", Global, "_clear_scores")
	# warning-ignore:return_value_discarded
	Global.connect("high_scores_cleared", self, "update_high_score_text")

	update_high_score_text()


func _on_Button_pressed(mode_name):
	Global.start_new_session(mode_name)
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/Intermission.tscn")


func update_high_score_text():
	$RichTextLabel.text = ""

	for mode in Global.high_scores.keys():
		$RichTextLabel.text += "\nHigh Score (" + mode + "): " + Global.high_scores[mode] as String
