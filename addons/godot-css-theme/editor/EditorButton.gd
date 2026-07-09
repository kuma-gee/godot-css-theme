@tool
extends BaseButton

var unfocus_color = Color("999999")

func _ready():
	modulate = unfocus_color
	mouse_entered.connect(func(): modulate = Color.WHITE)
	mouse_exited.connect(func(): modulate = unfocus_color)
