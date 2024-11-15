@tool
extends EditorPlugin

const EDITOR = preload("res://addons/godot-css-theme/editor/css_editor.tscn")

var file_editor
var import_plugin

func _enter_tree():
	file_editor = EDITOR.instantiate()
	file_editor.saved.connect(func(file): get_editor_interface().get_resource_filesystem().scan_sources())
	
	get_editor_interface().get_editor_main_screen().add_child(file_editor)
	_make_visible(false)

	import_plugin = preload("res://addons/godot-css-theme/import_plugin.gd").new();
	add_import_plugin(import_plugin)

func _exit_tree():
	get_editor_interface().get_editor_main_screen().remove_child(file_editor)
	remove_import_plugin(import_plugin)

func _has_main_screen():
	return true

func _get_plugin_name():
	return "CSS"

func _get_plugin_icon():
	return get_editor_interface().get_base_control().get_theme_icon("Theme", "EditorIcons")

func _make_visible(visible):
	if file_editor:
		file_editor.visible = visible
