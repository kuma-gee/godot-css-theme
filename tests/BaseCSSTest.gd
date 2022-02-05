class_name BaseCSSTest extends UnitTest


func create_theme_from_css(file: String) -> Theme:
	var theme = Theme.new()
	var theme_applier = ThemeApplier.new(theme)
	var parser = CSSParser.new()
	var stylesheet = parser.parse(file)
	theme_applier.apply_css(stylesheet)

	return theme
