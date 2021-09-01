class_name ThemeApplier

var EMPTY_STYLE = StyleBoxEmpty.new()

var _theme: Theme

func _init(theme: Theme):
	_theme = theme


func apply_css(stylesheet: Stylesheet) -> void:
	for node_type in stylesheet.get_classes():
		var properties = stylesheet.get_class_properties(node_type)
		
		if node_type == "body" or node_type == "*":
			if properties.has("font-family"):
				var url = stylesheet.resolve_url(properties.get("font-family"))
				if url:
					_theme.set("default_font", load(url))
			continue
		
		var style_properties = []
		var styles = {}
		
		for prop in properties:
			var property := prop as String
			var value := properties[prop] as String
			
			if property.begins_with("--colors-"):
				var type := _parse_type("--colors-", property)
				_theme.set_color(type, node_type, _create_value(stylesheet, value))
			elif property.begins_with("--const-"):
				var type := _parse_type("--const-", property)
				_theme.set_constant(type, node_type, _create_value(stylesheet, value))
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
					var type := _parse_type("--styles-", prop, false)
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
			var stylebox = styles[style]
			if stylebox is StyleBoxEmpty and _is_equal_stylebox(stylebox, EMPTY_STYLE):
				stylebox = EMPTY_STYLE
			_theme.set_stylebox(style.replace("-", "_"), node_type, stylebox)

func _is_equal_stylebox(style1: StyleBox, style2: StyleBox) -> bool:
	var prop1 = _get_properties(style1)
	var prop2 = _get_properties(style2)
	
	if prop1 != prop2:
		return false
	
	for prop in prop1:
		if style1.get(prop) != style2.get(prop):
			return false
	return true

func _get_properties(obj: Object) -> Array:
	var result = []
	for prop in obj.get_property_list():
		result.append(prop["name"])
	return result

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

func _parse_type(prefix: String, property: String, replace = true) -> String:
	var value = property.substr(prefix.length())
	if replace:
		value = value.replace("-", "_")
	return value

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
