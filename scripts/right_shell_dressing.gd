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
	label.text = create_and_return_tail()
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.label_settings = default_label_settings

func create_and_return_tail():
	var rng := RandomNumberGenerator.new()
	var tail: String = ""
	var left_letter: String = ""
	var right_number: String = ""
	
	rng.randomize()
	left_letter = passkey_letters_hex[rng.randi_range(0, passkey_letters_hex.length()-1)]
	right_number = passkey_numbers[rng.randi_range(0, passkey_numbers.length()-1)]
	tail = "<" + left_letter + right_number
	
	return tail
