class_name ThemeEdit

var _theme: Theme
var _node_type: String

func _init(theme: Theme, node_type: String):
	_theme = theme
	_node_type = node_type


func set_default_font_color(color: Color) -> void:
	set_font_color(color, ["", "disabled", "hover", "pressed"])

func set_default_style(style: StyleBox) -> void:
	set_style(style, ["normal", "disabled", "focus", "hover", "pressed"])

func set_style(style: StyleBox, states := []) -> void:
	for state in states:
		_theme.set_stylebox(state, _node_type, style)

func set_font_color(color: Color, states := []) -> void:
	for state in states:
		var prop = "font_color"
		if state != "":
			prop += "_" + state
		_theme.set_color(prop, _node_type, color)
