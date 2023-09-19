extends Microgame

onready var cupcake = $cupcake

func _ready() -> void:
	#sets player movement speed depending on session difficulty
	if is_difficulty_medium():
		cupcake.move = true
	if is_difficulty_hard():
		$hand.SPEED = 15
		cupcake.move = true

func _on_cupcake_collision_area_entered(_area):
	is_success = true
	cupcake.move = false


