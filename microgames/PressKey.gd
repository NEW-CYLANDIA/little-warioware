extends Microgame


func _input(event):
	if event.is_action_pressed("ui_select"):
		if win_by_default:
			is_success = false
			$RichTextLabel.text = "you lost :("
		else:
			if not is_success:
				is_success = true
				$RichTextLabel.text = "you win!"
