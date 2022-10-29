class_name Microgame
extends Node

signal report_result(is_success)

export (String) var microgame_name
export (String) var hint_verb
export (bool) var win_by_default = false

var is_success = false
var timer_scene = preload("res://scenes/MicrogameTimer.tscn")
var timer


func _ready():
	timer = timer_scene.instance()
	timer.connect("timeout", self, "_on_Timer_timeout")
	
	connect("report_result", Session, "_on_result_reported")

	is_success = win_by_default
	
	add_child(timer)


func _on_Timer_timeout():
	emit_signal("report_result", is_success)

	get_tree().change_scene("res://scenes/Intermission.tscn")
