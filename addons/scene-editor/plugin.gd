tool
extends EditorPlugin

const DOCK_SCENE = preload("res://addons/scene-editor/SceneEditor.tscn")
var dock

func _enter_tree():
	dock = DOCK_SCENE.instance()
	add_control_to_bottom_panel(dock, "Scene Editor")


func _exit_tree():
	remove_control_from_bottom_panel(dock)
	dock.free()
