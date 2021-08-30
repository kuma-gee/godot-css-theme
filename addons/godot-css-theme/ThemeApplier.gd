class_name ThemeApplier

const STATE_MAP = {
	"hover": "hover",
	"focus": "focus",
	"disabled": "disabled",
	"active": "pressed",
}

var EMPTY_STYLE = StyleBoxEmpty.new()

var _theme: Theme
var _current_style: StyleBox = EMPTY_STYLE


func _init(theme: Theme):
	_theme = theme


func apply_css(stylesheet: Stylesheet) -> void:
	for node_type in stylesheet.get_classes():
		var properties = stylesheet.get_class_properties(node_type)
		
		
		for prop in properties:
			var property := prop as String
			var value := properties[prop] as String
			
			if property.begins_with("--colors-"):
				var type := _parse_type("--colors-", property)
				_theme.set_color(type, node_type, Color(value))
			elif property.begins_with("--const-"):
				var type := _parse_type("--const-", property)
				_theme.set_constant(type, node_type, int(value))
			elif property.begins_with("--fonts-"):
				var type := _parse_type("--fonts-", property)
				var url := stylesheet.resolve_url(value)
				if url:
					_theme.set_font(type, node_type, load(url))
				else:
					print("Invalid url %s for class %s" % [value, node_type])
			elif property.begins_with("--icons-"):
				var type := _parse_type("--icons-", property)
				var url := stylesheet.resolve_url(value)
				if url:
					_theme.set_icon(type, node_type, load(url))
				else:
					print("Invalid url %s for class %s" % [value, node_type])
			elif property.begins_with("--styles-") and not property.ends_with("-type"):
				var type := _parse_type("--styles-", property)
				if _theme.has_stylebox(type, node_type):
					var style_type = properties.get("--styles-%s-type" % type)
					var style := _create_style(style_type)
					if style:
						_theme.set_stylebox(type, node_type, style)
					else:
						print("Invalid Style Type")
				
				if _theme.has_stylebox(type, node_type):
					var style = _theme.get_stylebox(type, node_type)
					style.set()
				
				

func _create_style(type: String) -> StyleBox:
	if type:
		match type:
			"Empty": return StyleBoxEmpty.new()
			"Flat": return StyleBoxFlat.new()
			"Line": return StyleBoxLine.new()
			"Texture": return StyleBoxTexture.new()
	return null

func _parse_type(prefix: String, property: String) -> String:
	return property.substr(prefix.length()).replace("-", "_")

#	_theme.set_color()
#
#	for cls in css.get_classes():
#		var type := _parse_class(cls)
#		var editor := ThemeEdit.new(_theme, type)
#
#		var normal = css.get_class_properties(cls)
#		_apply_normal_styles(editor, normal)
#
#		for state in STATE_MAP:
#			var props = css.get_class_properties(cls, state)
#			_apply_state_styles(editor, STATE_MAP[state], props)


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
		return style
	else:
		return EMPTY_STYLE
