class_name Options

var _options = {
	input = ['res://theme.css', 'CSS Input File'],
	output = ['res://theme.tres', 'Theme Output File'],
	config_file = ['res://.godot-css-config.json', 'Config file'],
}

var args: ArgumentParser

func init() -> bool:
	args = ArgumentParser.new()
	args.setup('Godot CSS to Theme converter', _options)
	return args.parse()

func get_value(key: String) -> String:
	if not args: return ""
	return args.get_value(key)
