extends KinematicBody2D

var eye_canvas : Node2D
export var velocity : float = 1
var m1_pressed : bool = false
# Liner follows the mouse cursor

func _ready():
	eye_canvas = get_parent().get_node("Canvas")


func _physics_process(delta):
	# Get cursor position
	var cursor_pos : Vector2 = get_global_mouse_position()
	var movement_vector : Vector2 = cursor_pos - position
	if position != cursor_pos:
		move_and_slide(movement_vector * velocity)
