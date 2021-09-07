tool
extends GraphNode

signal open_scene(path)

onready var name_label := $VBoxContainer/NameLabel
onready var open_button := $VBoxContainer/OpenScene

var resource := SceneResource.new()

func _ready():
	resource.connect("changed", self, "_update")
	_update()

func _on_SceneNode_resize_request(new_minsize):
	rect_size = new_minsize

func set_left_slot(slot: int, enabled: bool) -> void:
	set_slot(slot,
		enabled,
		get_slot_type_left(slot),
		get_slot_color_left(slot),
		is_slot_enabled_right(slot),
		get_slot_type_right(slot),
		get_slot_color_right(slot))

func set_name(name: String) -> void:
	resource.name = name

func _update():
	name_label.text = resource.name
	open_button.disabled = resource.scene == null


func _on_OpenScene_pressed():
	emit_signal("open_scene", resource.scene.resource_path)
