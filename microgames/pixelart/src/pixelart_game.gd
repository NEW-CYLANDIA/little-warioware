extends Microgame
# Called when the node enters the scene tree for the first time.

export(NodePath) var pencil_path;
onready var pencil:Pencil = get_node(pencil_path);
var camera_tween:SceneTreeTween;
func _ready() -> void:
	timer.stop();
	camera_tween = create_tween()
	var target_image:TileMap;
	if (session.level == Global.difficulty.EASY):
		target_image = $Image
		pencil.color = 14;
	if (session.level == Global.difficulty.MEDIUM):
		target_image = $Image2
		pencil.color = 10;
		pencil.pixels_to_draw = 3;
	if (session.level == Global.difficulty.HARD):
		target_image = $Image3
		pencil.color = 6;
		pencil.pixels_to_draw = 2;
	target_image.visible = true;
	pencil.img_tilemap = target_image;

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Pencil_drawing_done(is_correct) -> void:
	$Audio/WinSFX.play();
	print(camera_tween);
	is_success = true;
	$CameraTween.interpolate_property(
		$Camera2D, 
		"zoom", 
		$Camera2D.zoom, 
		$FinalCamera.zoom, 
		0.4,
		Tween.TRANS_BACK,
		Tween.EASE_OUT);
	$CameraTween.start();
	yield(get_tree().create_timer(0.5), "timeout");
	emit_signal("report_result", true);



func _on_Prompt_instructions_shown() -> void:
	timer.start(5);
