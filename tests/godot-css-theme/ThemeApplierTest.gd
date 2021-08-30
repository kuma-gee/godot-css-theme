extends UnitTest

const TEST_CSS = "res://tests/godot-css-theme/applier-test.css";

var css: CSSParser
var theme_applier: ThemeApplier
var theme: Theme
var stylesheet: Stylesheet

func before_each():
    theme = Theme.new()
    theme_applier = ThemeApplier.new(theme)
    css = CSSParser.new()
    stylesheet = css.parse(TEST_CSS)
    assert_not_null(stylesheet)


func test_apply_css():
    theme_applier.apply_css(stylesheet)

    assert_eq(theme.get_color("font_color", "Button"), Color('#000'))
    assert_eq(theme.get_color("font_color_disabled", "Button"), Color('#333'))
    assert_eq(theme.get_color("font_color_hover", "Button"), Color('#FFF'))
    assert_eq(theme.get_color("font_color_pressed", "Button"), Color('#999'))

    assert_eq(theme.get_constant("hseparation", "Button"), 10)

    assert_eq(theme.get_font("font", "Button").resource_path, "res://tests/godot-css-theme/font.tres")

    assert_eq(theme.get_icon("checked", "CheckBox").resource_path, "res://icon.png")