extends Node

signal level_up_requested
signal speed_up_requested

const GAME_MODE : Dictionary = {
	"STANDARD": preload("res://modes/mode_standard.tres"),
	"DEBUG": preload("res://modes/mode_debug.tres"),
}
const INTERMISSION_SCENE: PackedScene = preload("res://core/intermission/intermission.tscn")
const MENU_SCENE : PackedScene = preload("res://core/menu/menu.tscn")

var game_state : GameState
var microgame_pool : Array = []
var last_success : bool
var current_microgame : MicrogameDefinition


func _ready():
	randomize()
	connect("level_up_requested", self, "_on_level_up_requested")
	connect("speed_up_requested", self, "_on_speed_up_requested")

	# if microgame is being previewed directly, loop it
	var microgame_scene: String = ""
	for arg in OS.get_cmdline_args():
		if arg.begins_with("res://") and arg.ends_with(".tscn"):
			microgame_scene = arg
			# TODO - this will break if scene and def aren't identically named
			current_microgame = load(microgame_scene.replace(".tscn", ".tres"))
	if microgame_scene.length() > 0 or not OS.has_feature("editor"):
		game_state = GAME_MODE.DEBUG
		microgame_pool = [load(microgame_scene)]


func start_mode(game_mode : GameState):
	game_state = game_mode
	microgame_pool = Utility.get_microgames()

	_play_intermission()


func _play_intermission() -> void:
	get_tree().change_scene_to(INTERMISSION_SCENE)


func _on_intermission_completed() -> void:
	current_microgame = Utility.get_random_microgame(microgame_pool)
	
	if game_state.lives > 0:
		get_tree().change_scene_to(
			current_microgame.scene
		)
	else:
		Scores.save_score_for(game_state.name, game_state.current_score)
		get_tree().change_scene_to(MENU_SCENE)


func _on_microgame_completed(is_success : bool) -> void:
	# record last success for Intermission to reference
	last_success = is_success
	# always increase "score" count, even if failed
	game_state.current_score += 1

	# if not successful, remove a life
	if !is_success:
		game_state.lives -= 1

	_play_intermission()


func _on_level_up_requested() -> void:
	if game_state.level == GameState.Difficulty.EASY:
		game_state.level = GameState.Difficulty.MEDIUM
	elif game_state.level == GameState.Difficulty.MEDIUM:
		game_state.level = GameState.Difficulty.HARD


func _on_speed_up_requested() -> void:
	game_state.speed += 0.2
	Engine.time_scale = game_state.speed

