extends Node

var lives = 4
var score = 0

var microgame_scenes : Array


func _ready():
	get_microgame_scenes()


func _on_result_reported(is_success):
	if is_success:
		score += 1
	else:
		lives -= 1


func get_microgame_scenes():
	var dir = Directory.new()
	dir.open("res://microgames/")
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif file.get_extension() == "tscn":
			microgame_scenes.append("res://microgames/" + file)

	dir.list_dir_end()


func reset():
	lives = 4
	score = 0
