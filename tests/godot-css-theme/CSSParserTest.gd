extends UnitTest

var parser: CSSParser

func before_each():
	parser = CSSParser.new()

func test_parse():
	assert_true(parser.parse("res://tests/godot-css-theme/example.css"))
	assert_eq(parser.get_classes(), ["button", "h1", "body"])
	print(parser._values)
	
	var button = parser.get_class_properties('button')
	assert_eq_deep(button, {
		"background-color": "black",
		"color": "white",
		"padding": "2em",
	})
	
	var button_state = parser.get_class_properties('button', 'hover')
	assert_eq_deep(button_state, {"color": "black"})
	button_state = parser.get_class_properties('button', 'disabled')
	assert_eq_deep(button_state, {"color": "black"})
	button_state = parser.get_class_properties('button', 'focus')
	assert_eq_deep(button_state, {"color": "black"})
	button_state = parser.get_class_properties('button', 'active')
	assert_eq_deep(button_state, {"color": "black"})
	
	var body = parser.get_class_properties('body')
	assert_eq_deep(body, {
		"padding": "0",
		"margin": "0",
	})
	
	var h1 = parser.get_class_properties('h1')
	assert_eq_deep(h1, {
		"padding": "2em",
		"background-color": "black",
		"font-size": "10em",
		"color": "black",
	})
	
