extends Node
# A new Session is created upon starting a "round" of play
# Contains logic for tracking lives, score, etc

# An array of microgames to use this session
var microgame_scenes: Array = []
# The intermission scene
var intermission_scene: PackedScene = preload("res://src/play_session/intermission.tscn") as PackedScene

onready var yay := $Yay as AudioStreamPlayer
onready var nay := $Nay as AudioStreamPlayer


func _ready() -> void:
	cache_microgame_scenes()
	play_intermission()


func cache_microgame_scenes() -> void:
	microgame_scenes.clear()
	for file in Utility.find_microgames():
		var definition: Resource = load(file)
		if definition is MicrogameDefinition:
			microgame_scenes.append(definition.scene)


func get_random_microgame() -> PackedScene:
	return microgame_scenes[randi() % microgame_scenes.size()]


func play_intermission(last_was_success: bool = false) -> void:
	var intermission: Node = intermission_scene.instance()
	intermission.configure(last_was_success)
	add_child(intermission)
	yield(intermission, "intermission_done")
	remove_child(intermission)
	if Global.current_session.lives > 0:
		play_microgame()
	else:
		Global.end_current_session()


func play_microgame() -> void:
	var microgame: Node = get_random_microgame().instance()
	add_child(microgame)
	microgame.connect("microgame_ready", self, "configure_audio_nodes", [], CONNECT_ONESHOT)
	microgame.connect("play_yaynay", self, "play_yaynay")

	var is_success: bool = yield(microgame, "microgame_done")

	# always increase "score" count, even if failed
	Global.current_session.score += 1
	if !is_success:
		Global.current_session.lives -= 1

	remove_child(microgame)
	play_intermission(is_success)


func configure_audio_nodes(microgame_node: Node) -> void:
	var audio_nodes: Array = []
	var audio_nodes_2d: Array = []
	var audio_nodes_3d: Array = []

	Utility.find_by_class(microgame_node, "AudioStreamPlayer", audio_nodes)
	Utility.find_by_class(microgame_node, "AudioStreamPlayer2D", audio_nodes_2d)
	Utility.find_by_class(microgame_node, "AudioStreamPlayer3D", audio_nodes_3d)

	# set any microgame audio to pitch up along with session speed
	for audio_player in audio_nodes + audio_nodes_2d + audio_nodes_3d:
		audio_player.bus = "Session"
		audio_player.pitch_scale = Global.current_session.speed
	yay.pitch_scale = Global.current_session.speed
	nay.pitch_scale = Global.current_session.speed


func play_yaynay(status: bool) -> void:
	if status:
		yay.play()
	else:
		nay.play()
