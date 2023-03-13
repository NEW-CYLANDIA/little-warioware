extends Control
# Transition screen between microgames
# Displays current lives remaining, score,
# and increases in speed/difficulty


signal increment_modifier(type)
signal intermission_done()

onready var timer : Timer = $Timer as Timer
onready var score_display : RichTextLabel = $ScoreDisplay as RichTextLabel
onready var status_up : AnimatedSprite = $StatusUp as AnimatedSprite
onready var sfx_success : AudioStreamPlayer2D = $SuccessSFX as AudioStreamPlayer2D
onready var sfx_failure : AudioStreamPlayer2D = $FailureSFX as AudioStreamPlayer2D
onready var sfx_start : AudioStreamPlayer2D = $StartSFX as AudioStreamPlayer2D

var session : Session
var last_success : bool


func configure(current_session : Session, last_was_success : bool) -> void:
	session = current_session
	last_success = last_was_success


func _ready() -> void:
#	connect("increment_modifier", session, "increment_modifier")

	score_display.text = "Score: %d" % session.score

	# TODO: move into Session
	if session.lives <= 0:
		Engine.time_scale = 1
		timer.wait_time = 5
		($GameOver as CanvasItem).visible = true
		timer.start()
		sfx_failure.play()
		return

	sfx_success.pitch_scale = session.speed
	sfx_failure.pitch_scale = session.speed
	sfx_start.pitch_scale = session.speed

	# Launch the first game of the session if needed.
	if session.score <= 0:
		start_timer()
		return

	(sfx_success if last_success else sfx_failure).play()


func start_timer() -> void:
	if session.lives <= 0:
		return

	sfx_start.play()
	timer.start()

	# TODO: move into Session
	if session.score > 0:
		if session.score % session.level_up_interval == 0:
			show_modifier_update("level_up")
			emit_signal("increment_modifier", "level_up")
		elif session.score % session.speed_up_interval == 0:
			show_modifier_update("speed_up")
			emit_signal("increment_modifier", "speed_up")


func on_Timer_timeout() -> void:
	emit_signal("intermission_done")


func show_modifier_update(type : String) -> void:
	status_up.animation = type
	status_up.visible = true
	timer.wait_time *= 2
