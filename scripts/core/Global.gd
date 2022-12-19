extends Node
# Manages game state and stores metadata
# about current session and high scores


signal high_scores_cleared

enum difficulty { EASY = 1, MEDIUM = 2, HARD = 3 }

var timer_scene : PackedScene = preload("res://scenes/core/MicrogameTimer.tscn")

var modes = {
	"standard": {
		"starting_lives": 4,
		"starting_level": difficulty.EASY,
		"starting_speed": 1,
		"level_up_interval": 10,
		"speed_up_interval": 3,
	},
	"debug": {
		"starting_lives": 1,
		"starting_level": difficulty.EASY,
		"starting_speed": 1,
		"level_up_interval": 3,
		"speed_up_interval": 1,
	},
}

var high_scores : Dictionary

var current_session : Session


func _ready():
	load_scores()


func start_new_session(mode_name):
	current_session = Session.new(mode_name)

	return current_session


func load_scores():
	var file = File.new()
	if file.file_exists("user://save_score.dat"):
		file.open("user://save_score.dat", File.READ)
		high_scores = file.get_var()
		file.close()


func save_scores():
	var file = File.new()
	file.open("user://save_score.dat", File.WRITE)
	file.store_var(Global.high_scores, true)
	file.close()


func _clear_scores():
	Global.high_scores = {}
	save_scores()

	emit_signal("high_scores_cleared")


func _end_session():
	if !high_scores.has(current_session.mode):
		high_scores[current_session.mode] = 0

	if current_session.score > high_scores[current_session.mode]:
		high_scores[current_session.mode] = current_session.score

	save_scores()
	current_session.queue_free()
