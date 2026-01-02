extends Control

@onready var panel: Panel = %Panel
@onready var label: Label = %Label

var default_cell_stylebox = StyleBoxFlat.new()
var default_label_settings = LabelSettings.new()

var passkey_letters_hex = "ABCDEF"
var passkey_numbers = "0123456789"


func _ready():
	default_cell_stylebox.bg_color = Color.BLACK
	default_label_settings.set_font(preload("res://fonts/Perfect DOS VGA 437 Win.ttf"))
	default_label_settings.set_font_size(20)
	panel.set_anchors_preset(PRESET_FULL_RECT)
	panel.size = Vector2(0,0)
	setup()


func setup():
	panel.add_theme_stylebox_override("panel", default_cell_stylebox)
	memory_address_setup()
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.label_settings = default_label_settings

func memory_address_setup(pText: String = "0x-->", pBool: bool = false):
	if(pBool):
		label.text = "0x0" + pText + ">"
	else:
		label.text = "0x-->"
