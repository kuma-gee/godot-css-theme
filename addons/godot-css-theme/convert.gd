class_name CSSConvert
extends SceneTree


func _init():
	var options = Options.new()
	if not options.init():
		quit(1)
		return
	var debug = options.exists("debug")
	print("Debug: ", debug)


	var css_file = options.get_value("input")
	var output = options.get_value("output")

	convert_css(css_file, output, debug)

	quit()

static func convert_css(css_file, output, debug = false):
	var parser = CSSParser.new()

	if debug:
		print("Parsing Stylesheet")

	var stylesheet = parser.parse(css_file)
	if not stylesheet:
		return

	if debug:
		print("Simplifying Stylesheet")
	var simplifier = CSSSimplifier.new()
	var fullStylesheet = simplifier.simplify(stylesheet)


	if debug:
		print("Applying Stylesheet")
	var applier = ThemeApplier.new(debug)
	var themes = applier.apply_css(fullStylesheet)

	if debug:
		print("Creating theme")

	if not output:
		var last_slash = Options.find_last(css_file, "/")
		var file_name = css_file.substr(last_slash + 1)
		var dir_path = css_file.substr(0, last_slash)

		var file_name_without_ext = file_name.split(".")[0]
		output = dir_path + "/" + file_name_without_ext + ".tres"

	var output_dir = output.substr(0, Options.find_last(output, "/") + 1)
	print("Generating themes to %s" % output_dir)

	for theme_name in themes.keys():
		var theme = themes[theme_name]
		var theme_output = output_dir + theme_name + ".tres"
		if theme_name == "":
			theme_output = output
		
		var err = ResourceSaver.save(theme, theme_output)
		if err != OK:
			print("Failed to save theme %s" % err)
		else:
			print("Saved theme %s to %s" % [theme_name, theme_output])
