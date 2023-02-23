extends Node
# Manages game state and stores metadata about current session
# TODO: Nuke this class


enum difficulty { EASY = 1, MEDIUM = 2, HARD = 3 }

var modes : Dictionary

var current_session : Session


func _ready() -> void:
	for mode_path in ["res://src/core/mode_debug.tres", "res://src/core/mode_standard.tres"]:
		var mode = load(mode_path) as Object
		if mode is GameMode:
			modes[mode.name] = mode


func start_new_session(mode_name : String):
	current_session = Session.new(mode_name)

	return current_session


func end_session() -> void:
	current_session.queue_free()
