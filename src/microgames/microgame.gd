extends Node
class_name Microgame
# Base class for creating a microgame
# Custom microgames should extend this

var timer_scene: PackedScene = preload("res://src/microgames/microgame_timer.tscn")
var instruction_scene: PackedScene = preload("res://src/microgames/instructions.tscn")

# Emitted when microgame _ready() is complete
# Allows Session to do some last second config
signal microgame_ready(microgame_node)

# Emitted when timer finishes
# Reports player success or failure back to current session so score/lives can be updated accordingly
signal microgame_done(is_success)

# Full title of microgame
export(String) var microgame_name: String

# Short hint string to display when microgame starts
# Can be modified per play (e.g. different for higher difficulty levels)
export(String) var instructions_text: String

# Default success state for microgame
# Use "is_success" to update player's current success state
export(bool) var win_by_default: bool = false

# Set _true_ to report a win on microgame complete or _false_ to report a loss
var is_success: bool = false

# Reference to countdown timer before microgame ends
var timer: Timer
var instructions: Instructions

# Reference to current session
var session: Session = Global.current_session


func _ready() -> void:
	# Debug mode, allow looping the same game over and over when the scene is
	# ran on its own.
	if OS.has_feature("editor") and session == null:
		Global.start_new_single_session()
		session = Global.current_session

	# Set default success state.
	is_success = win_by_default

	# Create timer, connect signals.
	timer = timer_scene.instance() as Timer
	timer.connect("timeout", self, "on_Timer_timeout")

	# Create instructions, connect signals
	instructions = instruction_scene.instance() as Instructions
	instructions.connect("timeout", self, "on_Instructions_shown")

	var canvas_layer := CanvasLayer.new()
	canvas_layer.add_child(timer)
	canvas_layer.add_child(instructions)
	add_child(canvas_layer)

	# Start
	if instructions_text.length() > 0:
		instructions.show(instructions_text)
	else:
		instructions.queue_free()
		timer.call_deferred("start")

	# Let Session know microgame has finished loading.
	emit_signal("microgame_ready", self)


func on_Instructions_shown() -> void:
	timer.start()


func on_Timer_timeout() -> void:
	# Let session know the microgame is over
	emit_signal("microgame_done", is_success)
