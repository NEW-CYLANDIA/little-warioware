extends Node2D

var SPEED := 10
var can_move := true
func _physics_process(_delta):
	if can_move == true:
		if Input.is_action_pressed("mg_right"):
			if position.x <= 1000:
				position.x += SPEED
		if Input.is_action_pressed("mg_left"):
			if position.x >= 0:
				position.x -= SPEED
	if Input.is_action_just_pressed("mg_action") and can_move:
		$hand_sprites.play("released")
		can_move = false
		$cherry.falling = true
