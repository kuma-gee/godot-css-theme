tool
extends Control

onready var graph := $GraphEdit

func _ready():
	graph.add_main_node()

func _on_Button_pressed():
	graph.add_scene_node()
