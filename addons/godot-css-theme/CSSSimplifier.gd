class_name CSSSimplifier


# TODO: write test for conflicting properties with base syntax
func simplify(stylesheet: Stylesheet) -> Stylesheet:
	var values = {}

	for cls in stylesheet.get_classes():
		values[cls] = {}

		var new_props = {}

		for state in stylesheet.get_class_states(cls):
			var props = stylesheet.get_class_properties(cls, state)

			var style_prefix = "--styles-%s-" % state
			var style_type = style_prefix + "type"

			for prop in props.keys():
				var value = props[prop]
				if prop == "color":
					var mapped_prop = (
						"--colors-font-color"
						if state == Stylesheet.DEFAULT_STATE
						else "--colors-font-color-%s" % state
					)
					print(mapped_prop + " " + state)
					new_props[mapped_prop] = value
				elif prop == "background":
					new_props[style_type] = "Flat"
					new_props[style_prefix + "bg-color"] = value
				elif prop == "padding":
					if not new_props.has(style_type):
						new_props[style_type] = "Empty"

					var split = value.split(" ")
					var vValue = value
					var hValue = value
					if split.size() > 1:
						vValue = split[0]
						hValue = split[1]

					new_props[style_prefix + "content-margin-left"] = hValue
					new_props[style_prefix + "content-margin-right"] = hValue
					new_props[style_prefix + "content-margin-top"] = vValue
					new_props[style_prefix + "content-margin-bottom"] = vValue
				else:
					if state == Stylesheet.DEFAULT_STATE:
						new_props[prop] = value
					else:
						new_props[prop + "-" + state] = value

		values[cls][Stylesheet.DEFAULT_STATE] = new_props

	print(values)
	return Stylesheet.new(values, stylesheet.get_css_file())
