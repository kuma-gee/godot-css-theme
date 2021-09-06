tool
extends GraphNode

onready var scene_edit := $GridContainer/SceneEdit


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
