tool
extends GraphEdit

const SCENE_NODE = preload("res://addons/scene-editor/SceneNode.tscn")

func _ready():
	connect("connection_request", self, "connect_node")
	connect("disconnection_request", self, "disconnect_node")

func add_main_node():
	var node = _create_node()
	node.title = "Start Scene"
	node.set_left_slot(0, false)
	add_child(node)

func add_scene_node():
	add_child(_create_node())

func _get_node_count() -> int:
	return get_child_count() - 2 # Graph will contain a CLAYER node and main scene

func _create_node() -> GraphNode:
	var node = SCENE_NODE.instance()
	node.title = "Scene " + str(_get_node_count())
	node.connect("close_request", self, "_close_node", [node])
	
	return node

func _close_node(node: Node) -> void:
	remove_child(node)
