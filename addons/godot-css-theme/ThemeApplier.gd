class_name ThemeApplier

const STATE_MAP = {
	"hover": "hover",
	"focus": "focus",
	"disabled": "disabled",
	"active": "pressed",
}

var EMPTY_STYLE = StyleBoxEmpty.new()

var _theme: Theme


func _init(theme: Theme):
	_theme = theme


func apply_css(stylesheet: Stylesheet) -> void:
	for node_type in stylesheet.get_classes():
		var properties = stylesheet.get_class_properties(node_type)
		
		var style_properties = []
		var styles = {}
		
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
			elif property.begins_with("--styles-"):
				if property.ends_with("-type"):
					var type := _parse_type("--styles-", prop)
					type = type.substr(0, type.length() - "-type".length())
					var style := _create_style(properties[prop])
					styles[type] = style
				else:
					style_properties.append(property)
		
		for style in styles:
			for prop in style_properties:
				var prefix = "--styles-" + style + "-"
				if prop.begins_with(prefix):
					var type := _parse_type(prefix, prop)
					var value = _create_value(stylesheet, properties[prop])
					styles[style].set(type, value)
		
		for style in styles:
			print("set %s to %s" % [style, styles[style]])
			_theme.set_stylebox(style, node_type, styles[style])

func _create_value(stylesheet: Stylesheet, value: String):
	var url = stylesheet.resolve_url(value)
	if url != "":
		return url
	
	if value.begins_with("#"):
		return Color(value)
		
	
	return str2var(value)

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
