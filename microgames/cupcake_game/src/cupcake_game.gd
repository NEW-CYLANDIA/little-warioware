extends Microgame



func _ready() -> void:
	#sets player movement speed depending on session difficulty
	if is_level_medium():
		$cupcake.move = true
	if is_level_hard():
		$hand.SPEED = 15
		$cupcake.move = true

func _on_cupcake_collision_area_entered(_area):
	is_success = true
	$cupcake.move = false


