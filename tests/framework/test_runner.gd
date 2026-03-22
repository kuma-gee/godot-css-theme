extends SceneTree

const TEST_ROOT := "res://tests"
const TEST_SUFFIX := "Test.gd"

var _total_suites := 0
var _total_tests := 0
var _total_failures := 0


func _init() -> void:
	var started_usec := Time.get_ticks_usec()
	var test_files := _collect_test_files(TEST_ROOT)
	test_files.sort()

	if test_files.is_empty():
		printerr("No test files found in ", TEST_ROOT)
		quit(1)
		return

	print("Running ", test_files.size(), " test suites")

	for test_file in test_files:
		_run_suite(test_file)

	var elapsed_ms := int((Time.get_ticks_usec() - started_usec) / 1000)
	print("\nSummary")
	print("Suites: ", _total_suites, " | Tests: ", _total_tests, " | Failures: ", _total_failures, " | Time: ", elapsed_ms, "ms")

	quit(0 if _total_failures == 0 else 1)


func _collect_test_files(root: String) -> Array[String]:
	var results: Array[String] = []
	_collect_test_files_recursive(root, results)
	return results


func _collect_test_files_recursive(path: String, out: Array[String]) -> void:
	var dir := DirAccess.open(path)
	if dir == null:
		return

	dir.list_dir_begin()
	var entry := dir.get_next()
	while entry != "":
		if entry == "." or entry == "..":
			entry = dir.get_next()
			continue

		var full_path := path.path_join(entry)
		if dir.current_is_dir():
			_collect_test_files_recursive(full_path, out)
		elif entry.ends_with(TEST_SUFFIX):
			out.append(full_path)

		entry = dir.get_next()
	dir.list_dir_end()


func _run_suite(test_path: String) -> void:
	var script := load(test_path)
	if script == null:
		_total_failures += 1
		printerr("[SUITE-LOAD-FAIL] ", test_path)
		return
	if script is Script and not script.can_instantiate():
		_total_failures += 1
		printerr("[SUITE-COMPILE-FAIL] ", test_path)
		return

	var suite = script.new()
	if suite == null:
		_total_failures += 1
		printerr("[SUITE-INSTANTIATE-FAIL] ", test_path)
		return

	var test_names := _collect_test_names(suite)
	test_names.sort()
	if test_names.is_empty():
		return

	_total_suites += 1

	print("\nSuite: ", test_path, " (", test_names.size(), " tests)")

	suite.before_all()

	for test_name in test_names:
		_total_tests += 1
		suite._begin_test(test_path, test_name)
		suite.before_each()

		var before_count: int = suite.get_failure_count()
		suite.call(test_name)
		var after_count: int = suite.get_failure_count()

		if after_count == before_count:
			print("  PASS ", test_name)
			continue

		var new_failures: Array = suite.get_failures_since(before_count)
		_total_failures += new_failures.size()
		print("  FAIL ", test_name, " (", new_failures.size(), " assertion failure(s))")
		for failure in new_failures:
			printerr("    - ", failure.get("message", "Assertion failed"))


func _collect_test_names(suite: Object) -> Array[String]:
	var methods: Array[String] = []
	for method_meta in suite.get_method_list():
		var method_name: String = method_meta.get("name", "")
		if method_name.begins_with("test_"):
			methods.append(method_name)
	return methods
