@tool
class_name CSSImportPlugin
extends EditorImportPlugin

func _get_importer_name(): return "Godot CSS Importer"
func _get_visible_name(): return "Godot CSS Importer"
func _get_recognized_extensions(): return ["css"];
func _get_save_extension(): return "tres";
func _get_resource_type(): return "Theme";
func _get_priority(): return 1;
func _get_preset_count(): return 0;
func _get_import_order(): return 2;
func _can_import_threaded(): return true;
func _get_import_options(str, int): return [];
func _get_option_visibility(path: String, optionName: StringName, options: Dictionary): return true;

func _import(css_path: String, save_path: String, _o, _p, _g):
	var stylesheet = CSSParser.new().parse(css_path);

	if not stylesheet:
		return ERR_PARSE_ERROR;

	var full_stylesheet = CSSSimplifier.new().simplify(stylesheet);
	var themes = ThemeApplier.new().apply_css(full_stylesheet);

	var main_theme = themes.get("", null);
	if not main_theme:
		return ERR_PARSE_ERROR;

	return ResourceSaver.save(main_theme, save_path + ".tres");
