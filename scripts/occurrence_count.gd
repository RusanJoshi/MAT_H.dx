extends Control

@onready var panel: Panel = %Panel
@onready var label: Label = %Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var default_label_settings = LabelSettings.new()

var passkey_letters_hex = "ABCDEF"
var passkey_numbers = "0123456789"

func _ready():
	default_label_settings.set_font(preload("res://fonts/Perfect DOS VGA 437 Win.ttf"))
	default_label_settings.set_font_size(20)
	panel.set_anchors_preset(PRESET_FULL_RECT)
	panel.size = Vector2(0,0)
	setup()


func setup():
	memory_address_setup()
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.label_settings = default_label_settings

func memory_address_setup(pText: String = "0X925", pBool: bool = false):
	if(pBool):
		label.text = "0x0" + pText + ">"
	else:
		label.text = "else>"

func correct_flash(): 
	animation_player.play("correct_flash")

func incorrect_flash():
	animation_player.play("incorrect_flash")
	
