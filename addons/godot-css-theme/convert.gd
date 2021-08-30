extends SceneTree

func _init():
	var options = Options.new()
	if not options.init():
		quit(1)
		return
	
	var parser = CSSParser.new()
	var css_file = options.get_value("input")
	var stylesheet = parser.parse(css_file)
	if not stylesheet:
		quit(1)
		return
	
	var theme = Theme.new()
	var applier = ThemeApplier.new(theme)
	applier.apply_css(stylesheet)
	
#	for cls in parser.get_classes():
#		var normal = parser.get_class_properties(cls)
#		applier.apply_css(cls, normal)
		
#		var editor := ThemeEdit.new(_theme, cls)
#		_apply_normal_styles(editor, normal)
#
#		for state in STATE_MAP:
#			var props = css.get_class_properties(cls, state)
#			_apply_state_styles(editor, STATE_MAP[state], props)
	
	
	var output = options.get_value("output")
	var err = ResourceSaver.save(output, theme)
	if err != OK:
		print("Failed to save theme %s" % err)
		quit(1)
		return

	quit()
