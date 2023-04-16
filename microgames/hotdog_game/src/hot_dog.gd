extends AnimatedSprite


var FALL_SPEED = 16
var falling = false

func _ready():
	position.x = rand_range(200, 700)

func _physics_process(_delta):
	if falling == true:
		position.y += FALL_SPEED
	else:
		$falling.stop()



