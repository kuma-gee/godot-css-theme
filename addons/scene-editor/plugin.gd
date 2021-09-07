tool
extends EditorPlugin

const DOCK_SCENE = preload("res://addons/scene-editor/SceneEditor.tscn")
var dock

func _enter_tree():
	dock = DOCK_SCENE.instance()
	dock.interface = get_editor_interface()
	add_control_to_bottom_panel(dock, "Scene Editor")
	
	# TODO: only add if not existing
	add_autoload_singleton("SceneManager", "res://addons/scene-editor/SceneManager.gd")

func _exit_tree():
	remove_control_from_bottom_panel(dock)
	dock.free()
	
