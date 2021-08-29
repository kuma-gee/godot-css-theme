extends SceneTree

const CLASS_TYPE_MAP = {
	"button": "Button"
}

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
	
	
	
	theme.set_color("font_color", "Button", Color.black)
	
	var output = options.get_value("output")
	var err = ResourceSaver.save(output, theme)
	if err != OK:
		print("Failed to save theme %s" % err)
		quit(1)
		return

	quit()

