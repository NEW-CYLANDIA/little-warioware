extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var falling = false
var FALL_SPEED = 18
# Called when the node enters the scene tree for the first time.
func _ready():
	position.x = rand_range(200, 700)



func _physics_process(_delta):
	if falling == true:
		show()
		position.y += FALL_SPEED

