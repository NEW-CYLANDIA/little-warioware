extends Node2D

var shape_list = []

func _ready():
	pass # Replace with function body.
func _process(delta):
	if Input.is_mouse_button_pressed(1):
		if shape_list.empty() or shape_list[0] != get_local_mouse_position():
			shape_list.push_front(get_local_mouse_position())
		update()
func _draw():
	for pos in shape_list:
		draw_circle(pos, 3, Color.black)
