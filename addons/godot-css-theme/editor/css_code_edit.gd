@tool
extends CodeEdit

const TYPE_COLOR = Color("c46060")
const FN_COLOR = Color("2e8ff0")
const NUM_COLOR = Color("b383de")
const MEM_COLOR = Color("DDDDDD")
const FN_REGION_COLOR = Color("ffac63")
const STATE_COLOR = Color("339933")

 # TODO: does not support special characters except _
const SUPPORTED_CSS = [
	"color", "background", "font-family", "font-size",
	"gap", "padding",
	"border-width", "border-radius", "border-color"
]

func _ready():
	var syntax = syntax_highlighter as CodeHighlighter
	syntax.function_color = FN_COLOR
	syntax.number_color = NUM_COLOR
	syntax.symbol_color = TYPE_COLOR
	syntax.member_variable_color = MEM_COLOR

	if syntax.keyword_colors.is_empty():
		syntax.add_keyword_color("{", Color.RED)
		syntax.add_keyword_color("}", Color.RED)
		
	if syntax.color_regions.is_empty():
		syntax.add_color_region("(", ")", FN_REGION_COLOR)
		#syntax.add_color_region(":", ";", NUM_COLOR, true)
		syntax.add_color_region("--", ":", FN_COLOR)
	
	# Use theme to get available node types, re-import if new types get added
	if syntax.member_keyword_colors.is_empty():
		syntax.add_member_keyword_color("body", TYPE_COLOR)
		for type in load("res://syntax_theme.tres").get_type_list():
			syntax.add_member_keyword_color(type, TYPE_COLOR)
		
		for word in SUPPORTED_CSS:
			syntax.add_member_keyword_color(word, FN_COLOR)
	
#	for k in syntax.member_keyword_colors:
#		add_code_completion_option(CodeEdit.KIND_MEMBER, k, k)
#	code_completion_prefixes = ["--"]
#
#
#func _on_code_completion_requested():
#	push_warning("completion")
