extends Sprite

var move := false
var is_direction_right = true
const MOVE_SPEED = 10

func _ready():
	position.x = rand_range(100,800)

func _physics_process(_delta):
	if move:
		#stops cupcake from moving off screen
		if position.x >= 900:
			is_direction_right = false
		if position.x <= 0:
			is_direction_right = true
		if is_direction_right:
			position.x += MOVE_SPEED
		else:
			position.x -= MOVE_SPEED


func _on_cupcake_collision_area_entered(area):
	area.stop_fall()
