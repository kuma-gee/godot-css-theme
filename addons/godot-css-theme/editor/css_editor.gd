@tool
extends Control

@export var open_key: BaseButton
@export var export_key: BaseButton
@export var code: TextEdit
@export var file_name_label: Label

@onready var file_dialog = $FileDialog
@onready var export_dialog = $ExportDialog

var css_file: String : set = _set_css_file
var dirty = false : set = _set_dirty

func _set_dirty(d: bool):
	dirty = d
	_update_label()

func _set_css_file(f: String):
	css_file = f
	dirty = false
	_update_label()

# Did not find a better way to detect this
# The default editor save event using _notification does not work, because the variables will be empty?
func _input(event: InputEvent):
	if event is InputEventKey and event.keycode == KEY_S and event.ctrl_pressed:
		save_file(css_file)

func _ready():
	open_key.pressed.connect(func(): file_dialog.popup(Rect2i(0, 0, 700, 600)))
	export_key.pressed.connect(func(): export_dialog.popup(Rect2i(0, 0, 700, 600)))
	
	file_dialog.file_selected.connect(func(p): open_file(p))
	export_dialog.file_selected.connect(func(p): export_theme(p))
	
	code.text_changed.connect(func(): self.dirty = true)
	code.hide()
	export_key.hide()
	_update_label()

func _exit_tree():
	save_file()

func _update_label():
	if css_file:
		file_name_label.text = css_file
		if dirty:
			file_name_label.text += " (*)"
	else:
		file_name_label.text = ""

func open_file(path):
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		self.css_file = path
		code.text = file.get_as_text()
		code.show()
		export_key.show()
	else:
		push_error("Failed to open css file: %s" % path)

func save_file(path = css_file):
	if path:
		self.dirty = false
		var file = FileAccess.open(path, FileAccess.WRITE)
		if file:
			file.store_string(code.text)
		else:
			push_warning("Failed to save css file to path %s" % path)

func export_theme(path):
	save_file()
	CSSConvert.convert_css(css_file, path)
