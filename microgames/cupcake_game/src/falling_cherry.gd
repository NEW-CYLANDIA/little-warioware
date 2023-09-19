extends Node2D

const FALL_SPEED := 10
var is_falling := false

func _physics_process(_delta):
	if is_falling == true:
		position.y += FALL_SPEED

func start_fall():
	is_falling = true
func stop_fall():
	is_falling = false
