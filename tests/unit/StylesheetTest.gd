extends UnitTest


func test_resolve_url():
	var stylesheet = Stylesheet.new({}, "res://styles/test.css")
	assert_eq(stylesheet.resolve_url("url(local.txt)"), "res://styles/local.txt")
	assert_eq(stylesheet.resolve_url("url(res://styles/absolute.txt)"), "res://styles/absolute.txt")
	assert_eq(
		stylesheet.resolve_url("url(/styles/other_absolute.txt)"), "res://styles/other_absolute.txt"
	)


func test_group_by_classes():
	var stylesheet = Stylesheet.new(
		{"Button": {}, "Checkbox": {}, "Button.test-class": {}, "Label.test-class": {}}, ""
	)

	assert_eq(stylesheet.get_class_groups(), ["", "test-class"])

	assert_eq(stylesheet.get_classes(), ["Button", "Checkbox"])
	assert_eq(stylesheet.get_classes("test-class"), ["Button", "Label"])
