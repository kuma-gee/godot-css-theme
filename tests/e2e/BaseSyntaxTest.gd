extends BaseCSSTest

const TEST_CSS = "res://tests/e2e/base-syntax.css"

var theme: Theme
var themes: Dictionary


func before_all():
	themes = create_theme_from_css(TEST_CSS)
	theme = themes[""]


func test_font_color():
	assert_eq(theme.get_color("font_color", "Button"), Color("#000"))
	assert_eq(theme.get_color("font_disabled_color", "Button"), Color("#333"))
	assert_eq(theme.get_color("font_hover_color", "Button"), Color("#FFF"))
	assert_eq(theme.get_color("font_pressed_color", "Button"), Color(0, 0, 0, 0))
	assert_eq(theme.get_constant("hseparation", "Button"), 10)
	assert_eq(theme.get_font("font", "Button").resource_path, "res://tests/e2e/font.tres")


func test_style_box_empty():
	var empty = theme.get_stylebox("normal", "Button")
	assert_is(empty, StyleBoxEmpty)
	assert_eq(empty.get("content_margin_top"), 2.0)
	assert_eq(empty.get("content_margin_left"), 2.0)
	assert_eq(empty.get("content_margin_right"), 2.0)
	assert_eq(empty.get("content_margin_bottom"), 2.0)


func test_style_box_flat():
	var hover = theme.get_stylebox("hover", "Button")
	assert_is(hover, StyleBoxFlat)
	assert_eq(hover.get("bg_color"), Color("#FFF"))
	assert_eq(hover.get("draw_center"), false)
	assert_eq(hover.get("shadow_color"), Color("#333"))
	assert_eq(hover.get("shadow_size"), 5)
	assert_eq(hover.get("shadow_offset"), Vector2(1, 1))


func test_checkbox():
	assert_eq(theme.get_icon("checked", "CheckBox").resource_path, "res://icon.png")


func test_slider():
	var grabber_area = theme.get_stylebox("grabber_area", "HSlider")
	assert_eq(grabber_area.get("bg_color"), Color(0, 0, 0, 0))
	assert_eq(grabber_area.get("border_width_left"), 2)

	assert_eq(
		theme.get_stylebox("grabber_area_highlight", "HSlider"),
		theme.get_stylebox("slider", "HSlider")
	)


func test_classes():
	var classTheme = themes["test"]
	assert_eq(classTheme.get_color("font_color", "Button"), Color("#fff"))
	assert_eq(classTheme.get_color("font_color", "Label"), Color("#fff"))
	assert_eq(classTheme.get_color("font_disabled_color", "Label"), Color("#aaa"))
