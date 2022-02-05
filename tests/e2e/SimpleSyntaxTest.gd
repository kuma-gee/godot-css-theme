extends BaseCSSTest

const TEST_CSS = "res://tests/e2e/simple-syntax.css"

var theme: Theme


func before_all():
	theme = create_theme_from_css(TEST_CSS)


func test_global_font():
	assert_eq(theme.get("default_font").resource_path, "res://tests/e2e/font.tres")
