extends UnitTest

func test_resolve_url():
	var stylesheet = Stylesheet.new({}, "res://styles/test.css")
	assert_eq(stylesheet.resolve_url("url(local.txt)"), "res://styles/local.txt")
	assert_eq(stylesheet.resolve_url("url(res://styles/absolute.txt)"), "res://styles/absolute.txt")
	assert_eq(stylesheet.resolve_url("url(/styles/other_absolute.txt)"), "res://styles/other_absolute.txt")
