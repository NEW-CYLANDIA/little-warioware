extends Control
# Transition screen between microgames
# Displays current lives remaining, score,
# and increases in speed/difficulty


signal intermission_done()

onready var timer : Timer = $Timer as Timer
onready var score_display : RichTextLabel = $ScoreDisplay as RichTextLabel
onready var status_up : AnimatedSprite = $StatusUp as AnimatedSprite
onready var sfx_success : AudioStreamPlayer2D = $SuccessSFX as AudioStreamPlayer2D
onready var sfx_failure : AudioStreamPlayer2D = $FailureSFX as AudioStreamPlayer2D
onready var sfx_start : AudioStreamPlayer2D = $StartSFX as AudioStreamPlayer2D

var last_success : bool


func configure(last_was_success : bool) -> void:
	last_success = last_was_success


func _ready() -> void:
	score_display.text = "Score: %d" % Global.current_session.score

	# TODO: move into Session
	if Global.current_session.lives <= 0:
		Engine.time_scale = 1
		timer.wait_time = 5
		($GameOver as CanvasItem).visible = true
		timer.start()
		sfx_failure.play()
		return

	sfx_success.pitch_scale = Global.current_session.speed
	sfx_failure.pitch_scale = Global.current_session.speed
	sfx_start.pitch_scale = Global.current_session.speed

	# Launch the first game of the session if needed.
	if Global.current_session.score <= 0:
		start_timer()
		return

	(sfx_success if last_success else sfx_failure).play()


func start_timer() -> void:
	if Global.current_session.lives <= 0:
		return

	sfx_start.play()
	timer.start()

	if Global.current_session.score > 0:
		if Global.current_session.score % Global.current_session.level_up_interval == 0:
			show_modifier_update("level_up")
			Global.current_session.increment_modifier("level_up")
		elif Global.current_session.score % Global.current_session.speed_up_interval == 0:
			show_modifier_update("speed_up")
			Global.current_session.increment_modifier("speed_up")


func on_Timer_timeout() -> void:
	emit_signal("intermission_done")


func show_modifier_update(type : String) -> void:
	status_up.animation = type
	status_up.visible = true
	timer.wait_time *= 2
