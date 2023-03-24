extends Node
# Manages game state and stores metadata about current session
# TODO: Nuke this class

enum difficulty { EASY = 1, MEDIUM = 2, HARD = 3 }

const menu_scene: String = "res://src/menus/menu.tscn"
const play_scene: String = "res://src/play_session/play.tscn"

var modes: Dictionary

var current_session: Session = null


func _ready() -> void:
	for mode_path in ["res://src/core/mode_debug.tres", "res://src/core/mode_standard.tres"]:
		var mode = load(mode_path) as Object
		if mode is GameMode:
			modes[mode.name] = mode


func start_new_session(mode_name: String) -> void:
	current_session = Session.new(mode_name)
	get_tree().change_scene(Global.play_scene)


func start_new_single_session() -> void:
	var microgame_scene: String = ""
	for arg in OS.get_cmdline_args():
		if arg.begins_with("res://") and arg.ends_with(".tscn"):
			microgame_scene = arg
	# Early return if we didn't find the actual scene, or if we're not in the editor.
	if microgame_scene.length() <= 0 or not OS.has_feature("editor"):
		return

	start_new_session("debug")

	# Wait for one frame for the scene to change
	yield(get_tree(), "idle_frame")

	# Only keep the current microgame in the loaded list.
	get_tree().current_scene.microgame_scenes = [load(microgame_scene)]


func end_current_session() -> void:
	current_session.end_session()
	current_session = null
	get_tree().change_scene(Global.menu_scene)
