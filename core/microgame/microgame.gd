extends Node
class_name Microgame
# Base class for creating a microgame
# Custom microgames should extend this

const UI_SCENES : Dictionary = {
	"Instructions": preload("res://core/microgame/mg_instructions.tscn"),
	"Timer": preload("res://core/microgame/mg_timer.tscn"),
}

# Emitted when timer finishes
# Reports player success or failure back to current session so score/lives can be updated accordingly
signal microgame_completed(is_success)

# Short hint string to display when microgame starts
# Can be modified per play (e.g. different for higher difficulty levels)
export(String) var hint_verb: String

# Default success state for microgame
# Use "is_success" to update player's current success state
export(bool) var win_by_default : bool = false

# Use to delay gameplay start until after instructions appear
var is_timer_running : bool = false
# Set _true_ to report a win on microgame complete or _false_ to report a loss
var is_success : bool = false


func _ready() -> void:
	# set default success state
	is_success = win_by_default

	# Session will handle score update and
	# return to intermission on microgame complete
	connect("microgame_completed", Session, "_on_microgame_completed")

	# set any microgame audio to pitch up along with Session speed
	_sync_audio_nodes()

	# add additional UI elements
	var timer = UI_SCENES.Timer.instance()
	var instructions = UI_SCENES.Instructions.instance()
	var ui_parent = CanvasLayer.new()
	add_child(ui_parent)

	# wait for instructions to finish showing before adding timer
	ui_parent.add_child(instructions)
	instructions.prompt.text = hint_verb
	instructions.start()
	yield(instructions, "timeout")
	timer.connect("timeout", self, "_on_Timer_timeout")
	ui_parent.add_child(timer)
	is_timer_running = true


func get_current_speed() -> float:
	return Session.game_state.speed


func get_current_difficulty_level() -> int:
	return Session.game_state.level


func is_difficulty_easy():
	return Session.game_state.level == GameState.Difficulty.EASY


func is_difficulty_medium():
	return Session.game_state.level == GameState.Difficulty.MEDIUM


func is_difficulty_hard():
	return Session.game_state.level == GameState.Difficulty.HARD


func _sync_audio_nodes() -> void:
	var audio_nodes: Array = []
	var audio_nodes_2d: Array = []
	var audio_nodes_3d: Array = []

	Utility.find_by_class(self, "AudioStreamPlayer", audio_nodes)
	Utility.find_by_class(self, "AudioStreamPlayer2D", audio_nodes_2d)
	Utility.find_by_class(self, "AudioStreamPlayer3D", audio_nodes_3d)

	for audio_player in audio_nodes + audio_nodes_2d + audio_nodes_3d:
		audio_player.bus = "Session"
		audio_player.pitch_scale = get_current_speed()


func _on_Timer_timeout() -> void:
	is_timer_running = false
	# Let Session know the microgame is over
	emit_signal("microgame_completed", is_success)
