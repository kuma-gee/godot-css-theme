class_name Stylesheet

const DEFAULT_STATE = "normal"

var _values: Dictionary
var _css_file: String


func _init(values: Dictionary, file: String):
	_values = values
	_css_file = file


func get_css_file() -> String:
	return _css_file


func get_classes() -> Array:
	return _values.keys()


func get_class_states(cls: String) -> Array:
	if not _values.has(cls):
		return []
	return _values[cls].keys()


func get_class_properties(cls: String, state = DEFAULT_STATE) -> Dictionary:
	if not _values.has(cls):
		return {}
	if not _values[cls].has(state):
		return {}
	return _values[cls][state]


func resolve_url(value: String) -> String:
	if not value or not value.begins_with("url(") or not value.ends_with(")"):
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

	var last_slash = file.find_last("/")
	return file.substr(0, last_slash + 1)
