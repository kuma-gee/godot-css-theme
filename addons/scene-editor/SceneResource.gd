class_name SceneResource extends Resource

export var scene: PackedScene setget _set_scene
export var name: String setget _set_name

func _set_name(n) -> void:
	name = n
	emit_changed()

func _set_scene(s) -> void:
	scene = s
	emit_changed()
