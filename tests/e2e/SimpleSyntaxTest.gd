extends BaseCSSTest

const TEST_CSS = "res://tests/e2e/simple-syntax.css"

var theme: Theme


func before_all():
	theme = create_theme_from_css(TEST_CSS)[""]


func test_global_font():
	assert_eq(theme.get("default_font").resource_path, "res://tests/e2e/font.tres")


func test_simple_prop_mapping():
	assert_eq(theme.get_color("font_color", "Label"), Color("#FFF"))

	assert_eq(theme.get_font("font", "Label").resource_path, "res://tests/e2e/font_2.tres")

	# Since supporting border with background, doesnt' work for some reason
	var normal = theme.get_stylebox("normal", "Label")
	# assert_is(normal, StyleBoxFlat)
	# assert_eq(normal.get("bg_color"), Color("#000"))

	assert_eq(normal.get("content_margin_top"), 5.0)
	assert_eq(normal.get("content_margin_bottom"), 5.0)
	assert_eq(normal.get("content_margin_left"), 10.0)
	assert_eq(normal.get("content_margin_right"), 10.0)


func test_button_states():
	assert_eq(theme.get_color("font_color", "Button"), Color("#FFF"))
	assert_eq(theme.get_color("font_disabled_color", "Button"), Color("#FFF"))
	assert_eq(theme.get_color("font_hover_color", "Button"), Color("#FFF"))
	assert_eq(theme.get_color("font_pressed_color", "Button"), Color("#FFF"))
	assert_eq(theme.get_color("font_focus_color", "Button"), Color("#FFF"))

	assert_eq(theme.get_stylebox("normal", "Button").get("bg_color"), Color("#333"))
	assert_eq(theme.get_stylebox("disabled", "Button").get("bg_color"), Color("#333"))
	assert_eq(theme.get_stylebox("hover", "Button").get("bg_color"), Color("#333"))
	assert_eq(theme.get_stylebox("pressed", "Button").get("bg_color"), Color("#333"))
	assert_eq(theme.get_stylebox("focus", "Button").get("bg_color"), Color("#333"))
