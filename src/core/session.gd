extends Node
class_name Session
# A new Session is created upon starting a "round" of play
# Contains logic for tracking lives, score, etc


# An array of microgames to use this session
var microgame_scenes : Array setget protectedSet

# Mode selected for this session - used to track high scores
var mode : String setget protectedSet

# Player lives remaining this session
var lives : int setget protectedSet

# Microgames survived this session
var score : int setget protectedSet

# Current difficulty level this session
var level : int setget protectedSet

# Current speed this session
var speed : float setget protectedSet

# Speed will increase when score == a multiple of this number
var speed_up_interval : int setget protectedSet

# Level will increase when score == a multiple of this number
var level_up_interval : int setget protectedSet

# Result of last completed microgame
var last_success : bool setget protectedSet


# Restricts microgames from directly modifying player lives/score/etc
func protectedSet(_param):
	print("This value is read-only!")


func _init(mode_name : String) -> void:
	var mode_metadata = Global.modes[mode_name]

	mode = mode_name
	lives = mode_metadata.starting_lives
	level = mode_metadata.starting_level
	speed = mode_metadata.starting_speed
	speed_up_interval = mode_metadata.speed_up_interval
	level_up_interval = mode_metadata.level_up_interval
	score = 0

	get_microgame_scenes()


func get_microgame_scenes() -> void:
	var dir := Directory.new()
	dir.open("res://microgames/")
	dir.list_dir_begin()
	var file = dir.get_next()
	while file != "":
		if dir.current_is_dir():
			var inner_dir := Directory.new();
			inner_dir.open("res://microgames/" + file)
			inner_dir.list_dir_begin();
			var inner_file = inner_dir.get_next();
			while inner_file != "":
				if (inner_file.get_extension() == "tscn"):
					print(inner_file);
					microgame_scenes.append("res://microgames/" + file + "/" + inner_file)
				inner_file = inner_dir.get_next();
			inner_dir.list_dir_end();
			file = dir.get_next();

	dir.list_dir_end()


func get_random_microgame() -> String:
	return microgame_scenes[rand_range(0, microgame_scenes.size())]


func configure_audio_nodes(microgame_node : Node) -> void:
	var audio_nodes : Array = []
	var audio_nodes_2d : Array = []
	var audio_nodes_3d : Array = []

	Utility.find_by_class(microgame_node, "AudioStreamPlayer", audio_nodes)
	Utility.find_by_class(microgame_node, "AudioStreamPlayer2D", audio_nodes_2d)
	Utility.find_by_class(microgame_node, "AudioStreamPlayer3D", audio_nodes_3d)

	# set any microgame audio to pitch up along with session speed
	for audio_player in audio_nodes + audio_nodes_2d + audio_nodes_3d:
		audio_player.bus = "Session"
		audio_player.pitch_scale = speed


func on_result_reported(is_success):
	# always increase "score" count, even if failed
	score += 1

	if !is_success:
		lives -= 1

	last_success = is_success


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
