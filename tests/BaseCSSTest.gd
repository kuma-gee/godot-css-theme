class_name BaseCSSTest extends UnitTest


func create_theme_from_text(text: String, path = "") -> Dictionary:
	var parser = CSSParser.new()
	return _apply_stylesheet(parser.parse_text(text, path))


func create_theme_from_css(file: String) -> Dictionary:
	var parser = CSSParser.new()
	return _apply_stylesheet(parser.parse(file))


func _apply_stylesheet(style: Stylesheet) -> Dictionary:
	var theme_applier = ThemeApplier.new()
	return theme_applier.apply_css(_simplify(style))


func _simplify(style: Stylesheet) -> Stylesheet:
	var simplifier = CSSSimplifier.new()
	return simplifier.simplify(style)
