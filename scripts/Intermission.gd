extends Control


func _ready():
	$ScoreDisplay.text = Session.score as String


func get_random_microgame():
	return Session.microgame_scenes[rand_range(0, Session.microgame_scenes.size())]

func _on_Timer_timeout():
	get_tree().change_scene(get_random_microgame())
