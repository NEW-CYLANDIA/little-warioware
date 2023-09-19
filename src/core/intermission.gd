extends Control
# Transition screen between microgames
# Displays current lives remaining, score,
# and increases in speed/difficulty

signal intermission_completed

onready var instructions_scene = preload("res://src/microgame/mg_instructions.tscn")

onready var timer : Timer = $Timer
onready var score_display: RichTextLabel = $ScoreDisplay
onready var status_up: AnimatedSprite = $StatusUp
onready var sfx_success: AudioStreamPlayer2D = $SuccessSFX
onready var sfx_failure: AudioStreamPlayer2D = $FailureSFX
onready var sfx_start: AudioStreamPlayer2D = $StartSFX
onready var instructions_layer : CanvasLayer = $Instructions
onready var instructions_timer : Timer = $InstructionsTimer

var current_microgame_def : MicrogameDefinition


func _ready() -> void:
	var game_state : GameState = Session.game_state

	connect("intermission_completed", Session, "_on_intermission_completed")

	score_display.text = "Score: %d" % game_state.current_score

	# TODO: move into Session
	if game_state.lives <= 0:
		Engine.time_scale = 1
		timer.wait_time = 5
		instructions_timer.wait_time = 1
		$GameOver.visible = true
		timer.start()
		sfx_failure.play()
		return

	sfx_success.pitch_scale = game_state.speed
	sfx_failure.pitch_scale = game_state.speed
	sfx_start.pitch_scale = game_state.speed

	if game_state.current_score > 0:
		# play appropriate sound effect for pass/fail of last microgame
		var sfx_to_play : AudioStreamPlayer2D = (sfx_success if Session.last_success else sfx_failure)
		sfx_to_play.play()
		yield(sfx_to_play, "finished")

		if game_state.current_score % game_state.level_up_interval == 0:
			_show_modifier_update("level_up")
			Session.emit_signal("level_up_requested")
		elif game_state.current_score % game_state.speed_up_interval == 0:
			_show_modifier_update("speed_up")
			Session.emit_signal("speed_up_requested")

	sfx_start.play()
	timer.start()
	instructions_timer.start()


func on_Timer_timeout() -> void:
	emit_signal("intermission_completed", current_microgame_def)


func _show_modifier_update(type: String) -> void:
	status_up.animation = type
	status_up.visible = true
	timer.wait_time *= 2
	instructions_timer.wait_time *= 2


func _on_InstructionsTimer_timeout():
	current_microgame_def = Utility.get_random_microgame(Session.microgame_pool)
	# wait for instructions to finish showing before adding timer
	var instructions = instructions_scene.instance()
	instructions_layer.add_child(instructions)
	instructions.prompt.text = current_microgame_def.hint_verb
	instructions.start()
