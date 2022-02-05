class_name BaseCSSTest extends UnitTest


func create_theme_from_text(text: String, path = "") -> Theme:
	var parser = CSSParser.new()
	return _apply_stylesheet(parser.parse_text(text, path))


func create_theme_from_css(file: String) -> Theme:
	var parser = CSSParser.new()
	return _apply_stylesheet(parser.parse(file))


func _apply_stylesheet(style: Stylesheet) -> Theme:
	var theme = Theme.new()
	var theme_applier = ThemeApplier.new(theme)
	theme_applier.apply_css(_simplify(style))
	return theme


func _simplify(style: Stylesheet) -> Stylesheet:
	var simplifier = CSSSimplifier.new()
	return simplifier.simplify(style)
