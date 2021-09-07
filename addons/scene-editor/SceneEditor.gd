tool
extends Control

onready var graph := $GraphEdit

var interface: EditorInterface

func _ready():
	graph.add_main_node()


func _on_Button_pressed():
	graph.add_scene_node()


func _on_GraphEdit_node_selected(node):
	interface.edit_resource(node.resource)


func _on_GraphEdit_open_scene(path):
	interface.open_scene_from_path(path)
