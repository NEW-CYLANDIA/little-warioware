extends Microgame


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
export(NodePath) var easy_version_path;
export(NodePath) var medium_version_path;
export(NodePath) var hard_version_path;

onready var easy_version:Node2D = get_node(easy_version_path);
onready var medium_version:Node2D = get_node(medium_version_path);
onready var hard_version:Node2D = get_node(hard_version_path);

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var versions = [easy_version, medium_version, hard_version]
	for version in versions:
		remove_child(version);
		
	var version_to_use;
	if (session.level == Global.difficulty.EASY):
		version_to_use = easy_version;
	if (session.level == Global.difficulty.MEDIUM):
		version_to_use = medium_version
	if (session.level == Global.difficulty.HARD):
		version_to_use = hard_version;
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
