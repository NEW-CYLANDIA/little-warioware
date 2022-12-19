extends Control
# Transition screen between microgames
# Displays current lives remaining, score,
# and increases in speed/difficulty


signal increment_modifier(type)
signal end_session()

var session : Session = Global.current_session


func _ready():
	# warning-ignore:return_value_discarded
	connect("increment_modifier", session, "_increment_modifier")
	# warning-ignore:return_value_discarded
	connect("end_session", Global, "_end_session")

	$ScoreDisplay.text = "Score: " + session.score as String

	# TODO move into Session
	if session.lives == 0:
		Engine.time_scale = 1
		$Timer.wait_time = 5
		$GameOver.visible = true
		$Timer.start()
		$FailureSFX.play()
		return

	$SuccessSFX.pitch_scale = session.speed
	$FailureSFX.pitch_scale = session.speed
	$StartSFX.pitch_scale = session.speed

	# warning-ignore:return_value_discarded
	$SuccessSFX.connect("finished", self, "_start_timer")
	# warning-ignore:return_value_discarded
	$FailureSFX.connect("finished", self, "_start_timer")

	if session.score > 0:
		if session.last_success:
			$SuccessSFX.play()
		else:
			$FailureSFX.play()
	else:
		_start_timer()


func _start_timer():
	$StartSFX.play()
	$Timer.start()

	# TODO move into Session
	if session.score > 0:
		if session.score % session.level_up_interval == 0:
			show_modifier_update("level_up")
			emit_signal("increment_modifier", "level_up")
		elif session.score % session.speed_up_interval == 0:
			show_modifier_update("speed_up")
			emit_signal("increment_modifier", "speed_up")


func _on_Timer_timeout():
	if session.lives > 0:
		# warning-ignore:return_value_discarded
		get_tree().change_scene(session.get_random_microgame())
	else:
		emit_signal("end_session")
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://scenes/Menu.tscn")


func show_modifier_update(type):
	$StatusUp.animation = type
	$StatusUp.visible = true
	$Timer.wait_time *= 2
