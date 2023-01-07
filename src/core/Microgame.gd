class_name Microgame
extends Node
# Base class for creating a microgame
# Custom microgames should extend this


# Emitted when microgame _ready() is complete
# Allows Session to do some last second config
signal microgame_ready(microgame_node)

# Emitted when timer finishes
# Reports player success or failure back to current session so score/lives can be updated accordingly
signal report_result(is_success)

# Full title of microgame
export (String) var microgame_name : String

# Short hint string to display when microgame starts
# Can be modified per play (e.g. different for higher difficulty levels)
export (String) var hint_verb : String

# Default success state for microgame
# Use "is_success" to update player's current success state
export (bool) var win_by_default : bool = false

# Set _true_ to report a win on microgame complete or _false_ to report a loss
var is_success : bool = false

# Reference to countdown timer before microgame ends
var timer : Timer

# Reference to current session
var session : Session = Global.current_session


func _ready():
	# if playing microgame in isolation, create a temporary session
	if !session:
		session = Global.start_new_session("debug")

	# set default success state
	is_success = win_by_default

	# create timer, connect signals
	timer = Global.timer_scene.instance()

	# warning-ignore:return_value_discarded
	timer.connect("timeout", self, "_on_Timer_timeout")	
	# warning-ignore:return_value_discarded
	connect("report_result", session, "_on_result_reported")
	# warning-ignore:return_value_discarded
	connect("microgame_ready", session, "configure_audio_nodes")

	add_child(timer)

	# let Session know microgame has finished loading
	emit_signal("microgame_ready", self)


func _on_Timer_timeout():
	# Let session know the microgame is over
	emit_signal("report_result", is_success)

	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://src/core/Intermission.tscn")
