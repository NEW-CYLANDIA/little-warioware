extends Microgame
# Called when the node enters the scene tree for the first time.

export(NodePath) var camera_anim_path;
onready var camera_anim:AnimationPlayer = get_node(camera_anim_path)

func _ready() -> void:
	timer.start(5);


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Pencil_drawing_done(is_correct) -> void:
	camera_anim.play("Camera Zoom Out");
	var anim_length = camera_anim.get_animation("Camera Zoom Out").length;
	$WinSFX.play();
	is_success = true;
	
	yield(get_tree().create_timer(anim_length + 1), "timeout");
	emit_signal("report_result", true);

