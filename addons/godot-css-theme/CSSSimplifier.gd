class_name CSSSimplifier


# TODO: write test for conflicting properties with base syntax
func simplify(stylesheet: Stylesheet) -> Stylesheet:
	var values = {}

	for class_group in stylesheet.get_class_groups():
		values[class_group] = {}
		for cls in stylesheet.get_classes(class_group):
			values[class_group][cls] = {}

			var new_props = stylesheet.get_class_properties(cls, class_group, Stylesheet.DEFAULT_STATE).duplicate(
				true
			)

			for state in stylesheet.get_class_states(cls, class_group):
				var props = stylesheet.get_class_properties(cls, class_group, state).duplicate(true)

				var style_prefix = "--styles-%s-" % state
				var style_type = style_prefix + "type"

				if props.has("color"):
					var mapped_prop = (
						"--colors-font-color"
						if state == Stylesheet.DEFAULT_STATE
						else "--colors-font-color-%s" % state
					)
					new_props[mapped_prop] = props["color"]

				if props.has("background"):
					var value = props["background"]
					if value == "none":
						new_props[style_type] = "Empty"
					else:
						new_props[style_type] = "Flat"
						new_props[style_prefix + "bg-color"] = value

				if props.has("padding"):
					if not new_props.has(style_type):
						new_props[style_type] = "Empty"

					var value = props["padding"]
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

				if props.has("gap"):
					new_props["--const-separation"] = props["gap"]

			values[class_group][cls][Stylesheet.DEFAULT_STATE] = new_props

	return Stylesheet.new(values, stylesheet.get_css_file())
