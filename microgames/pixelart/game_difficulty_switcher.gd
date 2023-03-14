extends Microgame


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
export(NodePath) var easy_version_path;
export(NodePath) var medium_version_path;
export(NodePath) var hard_version_path;

onready var easy_version:Microgame = get_node(easy_version_path);
onready var medium_version:Microgame = get_node(medium_version_path);
onready var hard_version:Microgame = get_node(hard_version_path);

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var versions = [easy_version, medium_version, hard_version]
	for version in versions:
		remove_child(version);
		
	var version_to_use:Microgame
	print(session.level);
	if (session.level == Global.difficulty.EASY):
		version_to_use = easy_version;
	if (session.level == Global.difficulty.MEDIUM):
		version_to_use = medium_version
	if (session.level == Global.difficulty.HARD):
		version_to_use = hard_version;
	add_child(version_to_use);
	version_to_use.connect("microgame_ready", self, "microgame_ready");
	version_to_use.connect("microgame_done", self, "microgame-done")
	pass # Replace with function body.

func microgame_ready():
	emit_signal("microgame_ready");
func microgame_done():
	emit_signal("microgame_done");

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
