class_name UnitTest
extends RefCounted

var _failures: Array = []
var _current_suite_path := ""
var _current_test_name := ""


func before_all() -> void:
	pass


func before_each() -> void:
	pass


func _begin_test(suite_path: String, test_name: String) -> void:
	_current_suite_path = suite_path
	_current_test_name = test_name


func get_failure_count() -> int:
	return _failures.size()


func get_failures_since(index: int) -> Array:
	var safe_index := maxi(index, 0)
	return _failures.slice(safe_index)


func assert_eq(got, expected, message := "") -> bool:
	if got == expected:
		return true

	_record_failure(_compose_message(message, str("Expected ", _stringify(expected), ", got ", _stringify(got))))
	return false


func assert_eq_deep(got, expected, message := "") -> bool:
	if _deep_equal(got, expected):
		return true

	_record_failure(_compose_message(message, str("Expected (deep) ", _stringify(expected), ", got ", _stringify(got))))
	return false


func assert_not_null(value, message := "") -> bool:
	if value != null:
		return true

	_record_failure(_compose_message(message, "Expected non-null value"))
	return false


func assert_is(value, kind, message := "") -> bool:
	if is_instance_of(value, kind):
		return true

	_record_failure(_compose_message(message, str("Expected value to be instance of ", kind)))
	return false


func assert_true(condition: bool, message := "") -> bool:
	if condition:
		return true

	_record_failure(_compose_message(message, "Expected condition to be true"))
	return false


func _record_failure(message: String) -> void:
	_failures.append({
		"suite_path": _current_suite_path,
		"test_name": _current_test_name,
		"message": message,
	})


func _compose_message(prefix: String, fallback: String) -> String:
	if prefix.is_empty():
		return fallback
	return str(prefix, " | ", fallback)


func _stringify(value) -> String:
	return var_to_str(value)


func _deep_equal(left, right) -> bool:
	if left is Array and right is Array:
		if left.size() != right.size():
			return false

		for idx in left.size():
			if not _deep_equal(left[idx], right[idx]):
				return false
		return true

	if left is Dictionary and right is Dictionary:
		if left.size() != right.size():
			return false

		for key in left.keys():
			if not right.has(key):
				return false
			if not _deep_equal(left[key], right[key]):
				return false
		return true

	return left == right
