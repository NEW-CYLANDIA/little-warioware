extends Sprite


var FALL_SPEED := 10
var falling := false

func _physics_process(_delta):
	if falling == true:
		position.y += FALL_SPEED


func _on_cupcake_collision_area_entered(_area):
	falling = false
