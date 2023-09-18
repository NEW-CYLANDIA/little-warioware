extends Microgame

export(NodePath) var pencil_path
onready var pencil: Pencil = get_node(pencil_path)


func _ready() -> void:
	var target_image: TileMap

	match get_current_level():
		GameState.Difficulty.EASY:
			target_image = $Image
			pencil.color = 14
		GameState.Difficulty.MEDIUM:
			target_image = $Image2
			pencil.color = 10
			pencil.pixels_to_draw = 3
		GameState.Difficulty.HARD:
			target_image = $Image3
			pencil.color = 6
			pencil.pixels_to_draw = 2
	target_image.visible = true
	pencil.img_tilemap = target_image


func _on_Pencil_drawing_done() -> void:
	$Audio/WinSFX.play()
	is_success = true
	$CameraTween.interpolate_property(
		$Camera2D, "zoom", $Camera2D.zoom, $FinalCamera.zoom, 0.4, Tween.TRANS_BACK, Tween.EASE_OUT
	)
	$CameraTween.start()
	yield(get_tree().create_timer(0.5), "timeout")
