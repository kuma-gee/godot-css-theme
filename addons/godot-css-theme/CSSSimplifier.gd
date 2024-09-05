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
						else "--colors-font-%s-color" % state
					)
					new_props[mapped_prop] = props["color"]

				if props.has("gap"):
					new_props["--const-separation"] = props["gap"]

				if props.has("font-family"):
					var value = props["font-family"]
					new_props["--fonts-font"] = value

				if props.has("font-size"):
					new_props["--fonts-font-size"] = props["font-size"]

				if props.has("background"):
					var value = props["background"]
					var is_none = value == "none"

					new_props[style_type] = "Flat"
					var color = "Color(0, 0, 0, 0)" if is_none else value
					new_props[style_prefix + "bg-color"] = color

				if props.has("draw-center"):
					new_props[style_type] = "Flat"
					new_props[style_prefix + "draw-center"] = props["draw-center"]

				if props.has("skew"):
					new_props[style_type] = "Flat"
					_vector2(
						new_props,
						props["skew"],
						style_prefix + "skew"
					)

				if props.has("corner-detail"):
					new_props[style_type] = "Flat"
					new_props[style_prefix + "corner-detail"] = props["corner-detail"]

				if props.has("border-width"):
					new_props[style_type] = "Flat"
					_shorthand_sides(
						new_props, props["border-width"], style_prefix + "border-width"
					)

				if props.has("border-radius"):
					new_props[style_type] = "Flat"
					_shorthand_sides(
						new_props,
						props["border-radius"],
						style_prefix + "corner-radius",
						["top-left", "top-right", "bottom-right", "bottom-left"]
					)

				if props.has("border-color"):
					new_props[style_type] = "Flat"
					new_props[style_prefix + "border-color"] = props["border-color"]

				if props.has("border-blend"):
					new_props[style_type] = "Flat"
					new_props[style_prefix + "border-blend"] = props["border-blend"]

				if props.has("padding"):
					if not new_props.has(style_type):
						new_props[style_type] = "Empty"

					_shorthand_sides(new_props, props["padding"], style_prefix + "content-margin")

				if props.has("expand-margin"):
					new_props[style_type] = "Flat"
					_shorthand_sides(
						new_props,
						props["expand-margin"],
						style_prefix + "expand-margin",
					)

				if props.has("shadow-color"):
					new_props[style_type] = "Flat"
					new_props[style_prefix + "shadow-color"] = props["shadow-color"]

				if props.has("shadow-size"):
					new_props[style_type] = "Flat"
					new_props[style_prefix + "shadow-size"] = props["shadow-size"]

				if props.has("shadow-offset"):
					new_props[style_type] = "Flat"
					_vector2(
						new_props,
						props["shadow-offset"],
						style_prefix + "shadow-offset"
					)

				if props.has("anti-aliasing"):
					new_props[style_type] = "Flat"
					new_props[style_prefix + "anti-aliasing"] = props["anti-aliasing"]

				if props.has("anti-aliasing-size"):
					new_props[style_type] = "Flat"
					new_props[style_prefix + "anti-aliasing-size"] = props["anti-aliasing-size"]

			values[class_group][cls][Stylesheet.DEFAULT_STATE] = new_props

	return Stylesheet.new(values, stylesheet.get_css_file())


func _shorthand_sides(
	props: Dictionary, value: String, prefix: String, sides = ["top", "right", "bottom", "left"]
):
	var split = value.split(" ")

	# Usually: top, right, bottom, left
	var side_values = [value, value, value, value]

	if split.size() == 2:
		side_values[0] = split[0]
		side_values[1] = split[1]
		side_values[2] = split[0]
		side_values[3] = split[1]

	if split.size() == 4:
		side_values[0] = split[0]
		side_values[1] = split[1]
		side_values[2] = split[2]
		side_values[3] = split[3]

	for i in range(0, sides.size()):
		props[prefix + "-" + sides[i]] = side_values[i]


func _vector2(props: Dictionary, value: String, prefix: String):
	var split = value.split(" ")
	props[prefix] = "Vector2(%s)" % ", ".join(split)
