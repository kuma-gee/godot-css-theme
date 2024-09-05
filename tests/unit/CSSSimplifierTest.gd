extends BaseCSSTest


func test_map_classes():
	var themes = create_theme_from_text("Button.test {color: #333} Label.test {color: #333}")
	assert_true(themes.has("test"))
	assert_eq(themes["test"].get_color("font_color", "Button"), Color("#333"))
	assert_eq(themes["test"].get_color("font_color", "Label"), Color("#333"))


func test_map_color():
	var theme = create_theme_from_text("Button { color: #333}")[""]
	assert_eq(theme.get_color("font_color", "Button"), Color("#333"))


func test_map_color_from_state():
	var theme = create_theme_from_text("Button:disabled { color: #333}")[""]
	assert_eq(theme.get_color("font_disabled_color", "Button"), Color("#333"))


func test_map_background():
	var theme = create_theme_from_text("Button { background: #333 }")[""]
	var normal = theme.get_stylebox("normal", "Button")
	assert_eq(normal.get("bg_color"), Color("#333"))


func test_map_background_from_state():
	var theme = create_theme_from_text("Button:disabled { background: #333}")[""]
	var disabled = theme.get_stylebox("disabled", "Button")
	assert_eq(disabled.get("bg_color"), Color("#333"))


func test_map_background_none():
	var theme = create_theme_from_text("Button { background: none }")[""]
	var normal = theme.get_stylebox("normal", "Button")
	assert_eq(normal.get("bg_color").a, Color.TRANSPARENT.a)


func test_map_background_none_from_state():
	var theme = create_theme_from_text("Button:disabled { background: none }")[""]
	var disabled = theme.get_stylebox("disabled", "Button")
	assert_eq(disabled.get("bg_color").a, Color.TRANSPARENT.a)


func test_map_gap():
	var theme = create_theme_from_text("HBoxContainer { gap: 5 }")[""]
	assert_eq(theme.get_constant("separation", "HBoxContainer"), 5)


func test_map_padding():
	var theme = create_theme_from_text("Button { padding: 5 }")[""]
	var normal = theme.get_stylebox("normal", "Button")
	assert_eq(normal.get("content_margin_left"), 5.0)
	assert_eq(normal.get("content_margin_right"), 5.0)
	assert_eq(normal.get("content_margin_top"), 5.0)
	assert_eq(normal.get("content_margin_bottom"), 5.0)


func test_map_padding_horizontal_vertical():
	var theme = create_theme_from_text("Button { padding: 5 10 }")[""]
	var normal = theme.get_stylebox("normal", "Button")
	assert_eq(normal.get("content_margin_left"), 10.0)
	assert_eq(normal.get("content_margin_right"), 10.0)
	assert_eq(normal.get("content_margin_top"), 5.0)
	assert_eq(normal.get("content_margin_bottom"), 5.0)


func test_map_padding_all_sides():
	var theme = create_theme_from_text("Button { padding: 1 2 3 4 }")[""]
	var normal = theme.get_stylebox("normal", "Button")
	assert_eq(normal.get("content_margin_top"), 1.0)
	assert_eq(normal.get("content_margin_right"), 2.0)
	assert_eq(normal.get("content_margin_bottom"), 3.0)
	assert_eq(normal.get("content_margin_left"), 4.0)


func test_map_padding_from_state():
	var theme = create_theme_from_text("Button:disabled { padding: 5 }")[""]
	var disabled = theme.get_stylebox("disabled", "Button")
	assert_eq(disabled.get("content_margin_left"), 5.0)
	assert_eq(disabled.get("content_margin_right"), 5.0)
	assert_eq(disabled.get("content_margin_top"), 5.0)
	assert_eq(disabled.get("content_margin_bottom"), 5.0)


func test_map_border_width():
	var theme = create_theme_from_text("Button { border-width: 5 10 }")[""]
	var normal = theme.get_stylebox("normal", "Button")
	assert_eq(normal.get("border_width_top"), 5)
	assert_eq(normal.get("border_width_left"), 10)
	assert_eq(normal.get("border_width_right"), 10)
	assert_eq(normal.get("border_width_bottom"), 5)


func test_map_border_radius():
	var theme = create_theme_from_text("Button { border-radius: 2 5 }")[""]
	var normal = theme.get_stylebox("normal", "Button")
	assert_eq(normal.get("corner_radius_top_left"), 2)
	assert_eq(normal.get("corner_radius_top_right"), 5)
	assert_eq(normal.get("corner_radius_bottom_left"), 5)
	assert_eq(normal.get("corner_radius_bottom_right"), 2)


func test_map_border_color():
	var theme = create_theme_from_text("Button { border-color: #333 }")[""]
	var normal = theme.get_stylebox("normal", "Button")
	assert_eq(normal.get("border_color"), Color("#333"))


func test_map_padding_with_background():
	var theme = create_theme_from_text("Button { padding: 5; background: #000 }")[""]
	var normal = theme.get_stylebox("normal", "Button")
	assert_eq(normal.get("content_margin_left"), 5.0)
	assert_eq(normal.get("bg_color"), Color.BLACK)
