extends Sprite


var SPEED = 34
var can_move = true
func _ready():
	position.x = rand_range(600,1200)
func _physics_process(_delta):
	if Input.is_action_pressed("mg_right"):
		if position.x <= 1200:
			position.x += SPEED
	if Input.is_action_pressed("mg_left"):
		if position.x >= 600:
			position.x -= SPEED

