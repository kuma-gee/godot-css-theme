@tool
extends Control

signal saved(file)

# @export var open_key: BaseButton
@export var code: TextEdit
@export var file_name_label: Label
@export var files_list: Control

@onready var file_dialog = $FileDialog
@onready var export_dialog = $ExportDialog

var css_file: String: set = _set_css_file
var dirty = false: set = _set_dirty

func _set_dirty(d: bool):
	if d == dirty: return
	dirty = d
	for x in files_list.get_children():
		if x is Button and x.button_pressed:
			if dirty:
				x.text += " (*)"
			else:
				x.text = x.text.replace(" (*)", "")
			break

	_update_label()

func _set_css_file(f: String):
	if f == css_file: return
	css_file = f
	dirty = false
	_update_label()

func _update_files_list():
	for c in files_list.get_children():
		c.queue_free()
	
	_add_files_to_list_rec("res://")
	
func _add_files_to_list_rec(dir: String):
	var items = DirAccess.get_files_at(dir)
	for item in items:
		if item.get_extension() == "css":
			_add_to_list(dir, item)
	
	var dirs = DirAccess.get_directories_at(dir)
	for d in dirs:
		_add_files_to_list_rec("%s%s/" % [dir, d])

func _add_to_list(folder: String, file: String):
	var btn = Button.new()
	btn.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	btn.text = file
	btn.toggle_mode = true
	btn.alignment = HORIZONTAL_ALIGNMENT_LEFT

	var full_path = "%s/%s" % [folder, file]
	btn.button_pressed = css_file == full_path
	btn.pressed.connect(func(): open_file(full_path))
	files_list.add_child(btn)

# Did not find a better way to detect this
# The default editor save event using _notification does not work, because the variables will be empty?
func _input(event: InputEvent):
	if event is InputEventKey and event.keycode == KEY_S and event.ctrl_pressed:
		save_file(css_file)

func _ready():
	# open_key.pressed.connect(func(): file_dialog.popup(Rect2i(0, 0, 700, 600)))
	file_dialog.file_selected.connect(func(p): open_file(p))
	visibility_changed.connect(func(): _update_files_list())
	
	code.text_changed.connect(func(): self.dirty = true)
	code.hide()
	_update_label()
	_update_files_list()

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
	if dirty:
		save_file()

	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		self.css_file = path
		code.text = file.get_as_text()
		code.show()
	else:
		push_error("Failed to open css file: %s" % path)
	
	_update_files_list()

func save_file(path = css_file):
	if path:
		self.dirty = false
		var file = FileAccess.open(path, FileAccess.WRITE)
		if file:
			file.store_string(code.text)
			saved.emit(file)
		else:
			push_warning("Failed to save css file to path %s" % path)
