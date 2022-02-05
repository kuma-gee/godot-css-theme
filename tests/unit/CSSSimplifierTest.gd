extends BaseCSSTest


func test_map_color():
	var theme = create_theme_from_text("Button { color: #333}")
	assert_eq(theme.get_color("font_color", "Button"), Color("#333"))


func test_map_color_from_state():
	var theme = create_theme_from_text("Button:disabled { color: #333}")
	assert_eq(theme.get_color("font_color_disabled", "Button"), Color("#333"))


func test_map_background():
	var theme = create_theme_from_text("Button { background: #333 }")
	var normal = theme.get_stylebox("normal", "Button")
	assert_eq(normal.get("bg_color"), Color("#333"))


func test_map_background_from_state():
	var theme = create_theme_from_text("Button:disabled { background: #333}")
	var disabled = theme.get_stylebox("disabled", "Button")
	assert_eq(disabled.get("bg_color"), Color("#333"))


func test_map_background_none():
	var theme = create_theme_from_text("Button { background: none }")
	var normal = theme.get_stylebox("normal", "Button")
	assert_is(normal, StyleBoxEmpty)


func test_map_background_none_from_state():
	var theme = create_theme_from_text("Button:disabled { background: none }")
	var disabled = theme.get_stylebox("disabled", "Button")
	assert_is(disabled, StyleBoxEmpty)


func test_map_padding():
	var theme = create_theme_from_text("Button { padding: 5 }")
	var normal = theme.get_stylebox("normal", "Button")
	assert_eq(normal.get("content_margin_left"), 5.0)
	assert_eq(normal.get("content_margin_right"), 5.0)
	assert_eq(normal.get("content_margin_top"), 5.0)
	assert_eq(normal.get("content_margin_bottom"), 5.0)


func test_map_padding_horizontal_vertical():
	var theme = create_theme_from_text("Button { padding: 5 10 }")
	var normal = theme.get_stylebox("normal", "Button")
	assert_eq(normal.get("content_margin_left"), 10.0)
	assert_eq(normal.get("content_margin_right"), 10.0)
	assert_eq(normal.get("content_margin_top"), 5.0)
	assert_eq(normal.get("content_margin_bottom"), 5.0)


func test_map_padding_from_state():
	var theme = create_theme_from_text("Button:disabled { padding: 5 }")
	var disabled = theme.get_stylebox("disabled", "Button")
	assert_eq(disabled.get("content_margin_left"), 5.0)
	assert_eq(disabled.get("content_margin_right"), 5.0)
	assert_eq(disabled.get("content_margin_top"), 5.0)
	assert_eq(disabled.get("content_margin_bottom"), 5.0)
