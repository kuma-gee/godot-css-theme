class_name Stylesheet

const DEFAULT_STATE = "normal"

var _css_file: String
var _values: Dictionary = {"": {}}


func _init(values: Dictionary, file: String):
	_css_file = file
	_values = values


func get_css_file() -> String:
	return _css_file


func get_class_groups() -> Array:
	return _values.keys()


func get_classes(class_group = "") -> Array:
	if not _values.has(class_group):
		return []
	return _values[class_group].keys()


func get_class_states(cls: String, class_group = "") -> Array:
	if not _values[class_group].has(cls):
		return []
	return _values[class_group][cls].keys()


func get_class_properties(cls: String, class_group = "", state = DEFAULT_STATE) -> Dictionary:
	if not _values.has(class_group):
		return {}
	if not _values[class_group].has(cls):
		return {}
	if not _values[class_group][cls].has(state):
		return {}
	return _values[class_group][cls][state]


func resolve_url(value: String) -> String:
	if value == null or not value.begins_with("url(") or not value.ends_with(")"):
		return ""

	var url = value.substr(4, (value.length() - 1) - 4)

	if url.begins_with("res://"):
		return url
	if url.begins_with("/"):
		return "res:/" + url

	return _css_folder() + url


func _css_folder() -> String:
	var file := _css_file
	if file.ends_with("/"):
		file = file.substr(0, file.length() - 2)

	var last_slash = Options.find_last(file, "/")
	return file.substr(0, last_slash + 1)
