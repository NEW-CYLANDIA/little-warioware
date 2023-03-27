tool
extends EditorPlugin

const EXPECTED_MAJOR: int = 3
const EXPECTED_MINOR: int = 5
const EXPECTED_PATCH: int = -1  # -1 here means we don't care about the patch number


func _enter_tree() -> void:
	var version_info: Dictionary = Engine.get_version_info()

	if version_info["major"] != EXPECTED_MAJOR or version_info["minor"] != EXPECTED_MINOR:
		fail(version_info["string"].split("-")[0])
		return

	if EXPECTED_PATCH >= 0 and version_info["patch"] != EXPECTED_PATCH:
		fail(version_info["string"].split("-")[0])
		return


func fail(version: String) -> void:
	var dialog: AcceptDialog = AcceptDialog.new()
	dialog.window_title = "Invalid version"
	dialog.dialog_text = (
		"This project is not compatible with the version of Godot you are using (%s)"
		% version
	)
	dialog.connect("confirmed", dialog, "hide")
	dialog.connect("popup_hide", dialog, "queue_free")

	get_editor_interface().get_base_control().add_child(dialog)

	dialog.popup_centered()
