extends Microgame



func _ready() -> void:
	#sets player movement speed depending on session difficulty
	if session.level == Global.difficulty.EASY:
		$hand.SPEED = rand_range(20,22)
	if session.level == Global.difficulty.MEDIUM:
		$hand.SPEED = rand_range(30,36)
		$cupcake.move = true
	if session.level == Global.difficulty.HARD:
		$hand.SPEED = rand_range(40,46)
		$cupcake.move = true
		$cupcake.MOVE_SPEED = 18

func _on_cupcake_collision_area_entered(_area):
	is_success = true
	$cupcake.move = false


