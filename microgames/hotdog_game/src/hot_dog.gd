extends AnimatedSprite


var FALL_SPEED = 16
var is_falling = false

func _ready():
	position.x = rand_range(200, 700)

func _physics_process(_delta):
	if is_falling == true:
		position.y += FALL_SPEED



