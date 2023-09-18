extends Button

export(Resource) var mode_definition


func _on_pressed():
	Session.start_mode(mode_definition)
