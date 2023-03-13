extends Node
class_name Session


# Mode selected for this session - used to track high scores
var mode : String

# Player lives remaining this session
var lives : int

# Microgames survived this session
var score : int

# Current difficulty level this session
var level : int

# Current speed this session
var speed : float

# Speed will increase when score == a multiple of this number
var speed_up_interval : int

# Level will increase when score == a multiple of this number
var level_up_interval : int


func _init(mode_name : String) -> void:
	var mode_metadata = Global.modes[mode_name] as GameMode

	mode = mode_name
	lives = mode_metadata.starting_lives
	level = mode_metadata.starting_level
	speed = mode_metadata.starting_speed
	speed_up_interval = mode_metadata.speed_up_interval
	level_up_interval = mode_metadata.level_up_interval
	score = 0

func increment_modifier(type : String) -> void:
	if type == "speed_up":
		speed += 0.2
		Engine.time_scale = speed
	if type == "level_up":
		if level == GameMode.difficulty.EASY:
			level = GameMode.difficulty.MEDIUM
		elif level == GameMode.difficulty.MEDIUM:
			level = GameMode.difficulty.HARD


func end_session() -> void:
	Scores.save_score_for(mode, score)
	queue_free()
