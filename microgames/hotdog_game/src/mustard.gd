extends Sprite


var falling = false
var FALL_SPEED = 26
func _ready():
	position.x = rand_range(200, 700)

func _physics_process(_delta):
	if falling == true:
		show()
		position.y += FALL_SPEED
