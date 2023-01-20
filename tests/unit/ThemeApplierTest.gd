extends BaseCSSTest

# TODO: change to actual unit test
const TEST_CSS = "res://tests/unit/applier-test.css"

const CURRENT_DIR = "res://tests/unit"


func test_apply_css():
	var theme = create_theme_from_css(TEST_CSS)[""]

	assert_eq(theme.get("default_font").resource_path, "res://tests/unit/font.tres")
	assert_eq(theme.get("default_font").get("size"), 24)

	assert_eq(theme.get_color("font_color", "Button"), Color("#000"))
	assert_eq(theme.get_color("font_color_disabled", "Button"), Color("#333"))
	assert_eq(theme.get_color("font_color_hover", "Button"), Color("#FFF"))
	assert_eq(theme.get_color("font_color_pressed", "Button"), Color(0, 0, 0, 0))

	assert_eq(theme.get_constant("hseparation", "Button"), 10)

	assert_eq(theme.get_font("font", "Button").resource_path, "res://tests/unit/font.tres")

	assert_true(
		theme.get_stylebox("normal", "Button") is StyleBoxEmpty,
		"Expected normal style to be StyleBoxEmpty"
	)

	var hover = theme.get_stylebox("hover", "Button")
	assert_true(hover is StyleBoxFlat, "Expected hover style to be StyleBoxFlat")
	assert_eq(hover.get("bg_color"), Color("#FFF"))
	assert_eq(hover.get("shadow_size"), 5)

	assert_eq(theme.get_icon("checked", "CheckBox").resource_path, "res://icon.png")

	var grabber_area = theme.get_stylebox("grabber_area", "HSlider")
	assert_eq(grabber_area.get("bg_color"), Color(0, 0, 0, 0))
	assert_eq(grabber_area.get("border_width_left"), 2)

	assert_eq(
		theme.get_stylebox("grabber_area_highlight", "HSlider"),
		theme.get_stylebox("slider", "HSlider")
	)


func test_apply_font_family_for_ttf():
	var font_path = CURRENT_DIR + "/jackeyfont.ttf"
	var theme = create_theme_from_text("body { font-family: url(%s); }" % font_path)[""]

	var font = theme.get("default_font")
	assert_not_null(font, "Expected default_font to exist")

	var font_data = font.get("font_data")
	assert_not_null(font_data, "Expected font_data to exist")

	assert_eq(font_data.get("font_path"), font_path)

func test_apply_default_font_to_all_classes():
	var font_path = CURRENT_DIR + "/jackeyfont.tres"
	var theme = create_theme_from_text("body { font-family: url(%s); } Button.simple { color: #000}" % font_path)["simple"]

	var font = theme.get("default_font")
	assert_not_null(font, "Expected default_font to exist")

