extends Node
# Manages game state and stores metadata
# about current session and high scores


signal high_scores_cleared

enum difficulty { EASY = 1, MEDIUM = 2, HARD = 3 }

var modes : Dictionary
var high_scores : Dictionary

var current_session : Session


func _ready() -> void:
	load_scores()
	for mode_path in ["res://src/core/mode_debug.tres", "res://src/core/mode_standard.tres"]:
		var mode = load(mode_path) as Object
		if mode is GameMode:
			modes[mode.name] = mode


func start_new_session(mode_name : String):
	current_session = Session.new(mode_name)

	return current_session


func _end_session() -> void:
	if !high_scores.has(current_session.mode):
		high_scores[current_session.mode] = 0

	if current_session.score > high_scores[current_session.mode]:
		high_scores[current_session.mode] = current_session.score

	save_scores()
	current_session.queue_free()


# TODO: Move all the score stuff in its own class.

func load_scores() -> void:
	var file := File.new()
	if file.file_exists("user://save_score.dat"):
		file.open("user://save_score.dat", File.READ)
		high_scores = file.get_var()
		file.close()


func save_scores() -> void:
	var file := File.new()
	file.open("user://save_score.dat", File.WRITE)
	file.store_var(high_scores, true)
	file.close()


func _clear_scores() -> void:
	high_scores = {}
	save_scores()

	emit_signal("high_scores_cleared")
