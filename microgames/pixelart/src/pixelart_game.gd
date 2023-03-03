extends Microgame
# Called when the node enters the scene tree for the first time.

export(NodePath) var camera_anim_path;

var camera_tween:SceneTreeTween;
func _ready() -> void:
	timer.stop();
	camera_tween = create_tween()

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
