tool
extends GraphEdit

signal open_scene(path)

const SCENE_NODE = preload("res://addons/scene-editor/SceneNode.tscn")

func _ready():
	connect("connection_request", self, "connect_node")
	connect("disconnection_request", self, "disconnect_node")

func add_main_node():
	var node = _create_node()
	node.set_left_slot(0, false)
	node.set_name("Main Scene")
	node.show_close = false
	add_child(node)

func add_scene_node():
	add_child(_create_node())
	
func _get_node_count() -> int:
	return get_child_count() - 1 # Contains some CLAYER node

func _create_node() -> GraphNode:
	var node = SCENE_NODE.instance()
	node.title = "Scene"
	node.connect("close_request", self, "_close_node", [node])
	node.connect("open_scene", self, "_on_open_scene")
	node.set_name("Scene %s" % _get_node_count())
	
	return node

func _close_node(node: Node) -> void:
	remove_child(node)

func _on_open_scene(path: String) -> void:
	emit_signal("open_scene", path)
