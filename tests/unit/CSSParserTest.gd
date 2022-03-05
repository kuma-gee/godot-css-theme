extends UnitTest

var parser: CSSParser


func before_each():
	parser = CSSParser.new()


func test_parse():
	var stylesheet = parser.parse("res://tests/unit/parser-test.css")
	assert_not_null(stylesheet)

	assert_eq(stylesheet.get_classes(), ["button", "h1", "body", "Resource"])

	var button = stylesheet.get_class_properties("button")
	assert_eq_deep(
		button,
		{
			"background-color": "black",
			"color": "white",
			"padding": "2em",
		}
	)

	var button_state = stylesheet.get_class_properties("button", "hover")
	assert_eq_deep(button_state, {"color": "red"})
	button_state = stylesheet.get_class_properties("button", "focus")
	assert_eq_deep(button_state, {"color": "red"})
	button_state = stylesheet.get_class_properties("button", "disabled")
	assert_eq_deep(button_state, {"color": "black"})
	button_state = stylesheet.get_class_properties("button", "active")
	assert_eq_deep(button_state, {"color": "black"})

	var body = stylesheet.get_class_properties("body")
	assert_eq_deep(
		body,
		{
			"padding": "0",
			"margin": "0",
		}
	)

	var h1 = stylesheet.get_class_properties("h1")
	assert_eq_deep(
		h1,
		{
			"padding": "2em",
			"background-color": "black",
			"font-size": "10em",
			"color": "black",
		}
	)


func test_combine_same_tags():
	var stylesheet = parser.parse_text("Button { color: red } \n Button { padding: 1em }", "")
	var button = stylesheet.get_class_properties("Button")
	assert_eq_deep(button, {"color": "red", "padding": "1em"})

