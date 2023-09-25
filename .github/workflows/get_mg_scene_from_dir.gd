extends SceneTree


func _init():
    var mg_dir : String = OS.get_cmdline_args()[2]
    var def : MicrogameDefinition = Utility.find_microgame_definitions_in_dir(
        "res://microgames/" + mg_dir
    )[0]
    var mg_scene_path : String

    for filepath in Utility.list_all_files(def.resource_path.get_base_dir(), "tscn"):
        var scene_node = load(filepath).instance()
        var is_microgame_scene : bool = scene_node.get_class() == "Microgame"
        scene_node.free()

        if is_microgame_scene:
            mg_scene_path = filepath
            break

    var override_filepath := "override.cfg"

    ProjectSettings.set_setting("application/run/main_scene", mg_scene_path)
    ProjectSettings.save_custom(override_filepath)

    quit()
