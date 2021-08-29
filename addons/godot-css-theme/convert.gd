extends SceneTree

const CLASS_TYPE_MAP = {
	"button": "Button"
}

const SUPPORTED_STATES = [
	"hover",
	"focus",
	"disabled",
	"pressed"
]

func _init():
	var options = Options.new()
	if not options.init():
		quit(1)
		return
	
	var parser = CSSParser.new()
	var css_file = options.get_value("input")
	if not parser.parse(css_file):
		quit(1)
		return
	
	var theme = Theme.new()
	
	for cls in parser.get_classes():
		if not CLASS_TYPE_MAP.has(cls): continue
		
		var type = CLASS_TYPE_MAP.get(cls)
		var supported = theme.get_type_list(type)
		var normal = parser.get_class_properties(cls)
		
		var editor := ThemeEdit.new(theme, type)
		_apply_normal_styles(editor, normal)
		
		for state in SUPPORTED_STATES:
			_apply_state_styles(editor, state, parser.get_class_properties(cls, state))
		
		
	
	var output = options.get_value("output")
	var err = ResourceSaver.save(output, theme)
	if err != OK:
		print("Failed to save theme %s" % err)
		quit(1)
		return

	quit()

func _apply_normal_styles(editor: ThemeEdit, properties: Dictionary) -> void:
	var style = _create_background_style(properties)
	editor.set_default_style(style)
	
	if properties.has("color"):
		editor.set_default_font_color(Color(properties["color"]))

func _apply_state_styles(editor: ThemeEdit, state: String, properties: Dictionary) -> void:
	var style = _create_background_style(properties)
	editor.set_style(style, [state])

	if properties.has("color"):
		editor.set_font_color(Color(properties["color"]), [state])


func _create_background_style(props: Dictionary) -> StyleBox:
	if props.has("background-color"):
		var style = StyleBoxFlat.new()
		style.set("bg_color", Color(props["background-color"]))
		style.set("border_color", Color.red)
		return style
	else:
		return StyleBoxEmpty.new()

