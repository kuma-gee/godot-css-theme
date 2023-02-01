class_name Options

var _options = {
	input = ['', 'CSS Input File'],
	output = ['', 'Theme Output File'],
	debug = [false, 'Enable debug mode']
}

var args = OptParse.new()

func init() -> bool:
	args.add("--input", "", "CSS Input File")
	args.add("--output", "", "Theme Output File")
	args.add("--debug", false, "Enable debug mode")
	args.set_banner("Godot CSS to Theme converter")

	return args.parse()

func get_value(key: String):
	if not args: return ""
	return args.get_value("--" + key)

func exists(key: String):
	return get_value(key) != null


static func find_last(str: String, char: String) -> int:
	var found = []
	var current_idx = 0
	var times_called = 0
	
	while current_idx < str.length():
		var search = str.find(char, current_idx + 1)
		if search == -1:
			break
		
		found.append(search)
		current_idx = search
		times_called += 1

		if times_called > 100:
			break

	return found[-1]
