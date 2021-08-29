# ##############################################################################
#(G)odot (U)nit (T)est class (https://github.com/bitwes/Gut)
#
# ##############################################################################
# The MIT License (MIT)
# =====================
#
# Copyright (c) 2020 Tom "Butch" Wesley
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
# ##############################################################################
# Description
# -----------
# Command line interface for the GUT unit testing tool.  Allows you to run tests
# from the command line instead of running a scene.  Place this script along with
# gut.gd into your scripts directory at the root of your project.  Once there you
# can run this script (from the root of your project) using the following command:
# 	godot -s -d test/gut/gut_cmdln.gd
#
# See the readme for a list of options and examples.  You can also use the -gh
# option to get more information about how to use the command line interface.
# ##############################################################################

# ------------------------------------------------------------------------------
# Helper class to resolve the various different places where an option can
# be set.  Using the get_value method will enforce the order of precedence of:
# 	1.  command line value
#	2.  config file value
#	3.  default value
#
# The idea is that you set the base_opts.  That will get you a copies of the
# hash with null values for the other types of values.  Lower precedented hashes
# will punch through null values of higher precedented hashes.
# ------------------------------------------------------------------------------
#
# Slighly modified to make it more generic

class_name ArgumentParser

var base_opts = null
var cmd_opts = null
var config_opts = null

var _banner := ""
var _default_options := {}

const CONFIG_ARG = "config_file"
const HELP_ARG = ["--help", "-h"]

func setup(banner: String, options: Dictionary) -> bool:
	if not options.has(CONFIG_ARG): return false
	
	_banner = banner
	_default_options = options
	
	var opts = {}
	for opt in _default_options:
		var value = _default_options[opt] as Array
		if value.size() != 2: return false
		opts[opt] = value[0]
	set_base_opts(opts)
	return true

func get_value(key):
	return _nvl(cmd_opts[key], _nvl(config_opts[key], base_opts[key]))

func set_base_opts(opts):
	base_opts = opts
	cmd_opts = _null_copy(opts)
	config_opts = _null_copy(opts)

# creates a copy of a hash with all values null.
func _null_copy(h):
	var new_hash = {}
	for key in h:
		new_hash[key] = null
	return new_hash

func _nvl(a, b):
	if(a == null):
		return b
	else:
		return a

func _string_it(h):
	var to_return = ''
	for key in h:
		to_return += str('(',key, ':', _nvl(h[key], 'NULL'), ')')
	return to_return

func to_s():
	return str("base:\n", _string_it(base_opts), "\n", \
			   "config:\n", _string_it(config_opts), "\n", \
			   "cmd:\n", _string_it(cmd_opts), "\n", \
			   "resolved:\n", _string_it(get_resolved_values()))

func get_resolved_values():
	var to_return = {}
	for key in base_opts:
		to_return[key] = get_value(key)
	return to_return

func to_s_verbose():
	var to_return = ''
	var resolved = get_resolved_values()
	for key in base_opts:
		to_return += str(key, "\n")
		to_return += str('  default: ', _nvl(base_opts[key], 'NULL'), "\n")
		to_return += str('  config:  ', _nvl(config_opts[key], ' --'), "\n")
		to_return += str('  cmd:     ', _nvl(cmd_opts[key], ' --'), "\n")
		to_return += str('  final:   ', _nvl(resolved[key], 'NULL'), "\n")

	return to_return

func _setup_options():
	var opts = OptParse.new()
	opts.set_banner(_banner)
	
	for opt in _default_options:
		var values = _default_options[opt] as Array
		if values.size() != 2: continue
		
		opts.add(_build_cmd_option(opt), values[0], values[1])
		
	return opts

func _build_cmd_option(opt: String) -> String:
	return '--%s' % opt

# Parses options, applying them to the _tester or setting values
# in the options struct.
func _extract_command_line_options(from, to):
	for opt in _default_options:
		to[opt] = from.get_value(_build_cmd_option(opt))


func _load_options_from_config_file(file_path, into):
	# SHORTCIRCUIT
	var f = File.new()
	if(!f.file_exists(file_path)):
		if(file_path != _default_options[CONFIG_ARG][0]):
			print('ERROR:  Config File "', file_path, '" does not exist.')
			return -1
		else:
			return 1

	f.open(file_path, f.READ)
	var json = f.get_as_text()
	f.close()

	var results = JSON.parse(json)
	# SHORTCIRCUIT
	if(results.error != OK):
		print("\n\n",'!! ERROR parsing file:  ', file_path)
		print('    at line ', results.error_line, ':')
		print('    ', results.error_string)
		return -1

	# Get all the options out of the config file using the option name.  The
	# options hash is now the default source of truth for the name of an option.
	for key in into:
		if(results.result.has(key)):
			into[key] = results.result[key]

	return 1

func _print_gutconfigs(values):
	var header = """Here is a sample of a full .gutconfig.json file.
You do not need to specify all values in your own file.  The values supplied in
this sample are what would be used if you ran gut w/o the -gprint_gutconfig_sample
option (the resolved values where default < .gutconfig < command line)."""
	print("\n", header.replace("\n", ' '), "\n\n")
	var resolved = values

	# remove some options that don't make sense to be in config
	resolved.erase("config_file")
	resolved.erase("show_help")

	print("Here's a config with all the properties set based off of your current command and config.")
	var text = JSON.print(resolved)
	print(text.replace(',', ",\n"))

	for key in resolved:
		resolved[key] = null

	print("\n\nAnd here's an empty config for you fill in what you want.")
	text = JSON.print(resolved)
	print(text.replace(',', ",\n"))

func parse() -> bool:
	var o = _setup_options()

	var all_options_valid = o.parse()
	_extract_command_line_options(o, cmd_opts)
	var load_result = \
			_load_options_from_config_file(get_value(CONFIG_ARG), config_opts)

	if load_result == -1 or not all_options_valid:
		return false
	return true
