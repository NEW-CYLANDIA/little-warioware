tool
extends EditorPlugin


const MG_EXAMPLE_PATH := "res://core/microgame/example"
const MG_EXAMPLE_NAME := "my_cool_microgame"

var dock
var active_mg_def
var new_mg_just_created : bool = false


func _enter_tree():
	# Initialization of the plugin goes here.
	# Load the dock scene and instance it.
	# dock = preload("res://addons/my_custom_dock/my_dock.tscn").instance()

	# dock.get_node("VBoxContainer/Button").connect("pressed", self, "_on_button_pressed")
	add_tool_menu_item("Create New Microgame", self, "_on_button_pressed")

	connect("scene_changed", self, "_on_scene_changed")

	# Add the loaded scene to the docks.
	# add_control_to_dock(DOCK_SLOT_LEFT_BR, dock)
	# Note that LEFT_UL means the left of the editor, upper-left dock.


func _exit_tree():
	remove_tool_menu_item("Create New Microgame")
	# Clean-up of the plugin goes here.
	# Remove the dock.
	# remove_control_from_docks(dock)
	# Erase the control from the memory.
	# dock.free()


func _on_scene_changed(scene_root):
	if new_mg_just_created:
		active_mg_def = Utility.get_definition_from_microgame_scene(scene_root.filename)
		active_mg_def.scene = load(scene_root.filename)
		yield(get_tree().create_timer(0.1), "timeout")
		get_editor_interface().edit_resource(active_mg_def)
		new_mg_just_created = false

func _on_button_pressed(_ud):
	var example_dir = MG_EXAMPLE_PATH
	var new_mg_dir = "res://microgames/%s/" % MG_EXAMPLE_NAME

	var dir = Directory.new()
	dir.make_dir(new_mg_dir)
	for file in Utility.list_all_files(example_dir):
		dir.copy(file, new_mg_dir + file.get_file())
	get_editor_interface().get_resource_filesystem().scan()
	new_mg_just_created = true
	get_editor_interface().open_scene_from_path(new_mg_dir + "microgame.tscn")
