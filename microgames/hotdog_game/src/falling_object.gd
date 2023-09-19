extends Node2D

export var FALL_SPEED : int
var is_falling = false
export var min_position : int
export var max_position : int

func _ready():
	position.x = rand_range(min_position, max_position)

func _physics_process(_delta):
	if is_falling == true:
		position.y += FALL_SPEED

func start_fall():
	is_falling = true

func stop_fall():
	is_falling = false

