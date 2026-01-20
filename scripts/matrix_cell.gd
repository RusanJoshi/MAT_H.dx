extends Control 

@onready var vpasp: VariablePitchAudioStreamPlayer = $VPASP
@onready var cell_panel: Panel = %CellPanel
@onready var cell_label: Label = %CellLabel
@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

var default_cell_stylebox = StyleBoxFlat.new()
var default_label_settings = LabelSettings.new()

var segcode_visual: String = ""
var segcode_actual: String = ""
var passkey_letters_full = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
var passkey_letters_hex = "ABCDEF"
var passkey_numbers = "0123456789"
var default_font_size: int = 20
var hover_font_size: int = 22


func _ready():
	default_cell_stylebox.bg_color = Color.BLACK
	default_label_settings.set_font(preload("res://fonts/Perfect DOS VGA 437 Win.ttf"))
	default_label_settings.set_font_size(default_font_size)
	cell_panel.set_anchors_preset(PRESET_FULL_RECT)
	cell_panel.size = Vector2(0,0)
	setup()
	cell_panel.resized.connect(update_collision_shape_size_and_position)


func setup():
	cell_panel.add_theme_stylebox_override("panel", default_cell_stylebox)
	create_and_set_segment_code()
	cell_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	cell_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	cell_label.label_settings = default_label_settings

func update_collision_shape_size_and_position():
	var rect_size = cell_panel.size
	if collision_shape_2d.shape is RectangleShape2D:
		collision_shape_2d.shape.size = rect_size
		collision_shape_2d.position = rect_size/2

func create_and_set_segment_code():
	var rng := RandomNumberGenerator.new()
	var segcode_letter: String = ""
	var segcode_number: String = ""
	
	rng.randomize()
	segcode_letter = passkey_letters_hex[rng.randi_range(0, passkey_letters_hex.length()-1)]
	segcode_number = passkey_numbers[rng.randi_range(0, passkey_numbers.length()-1)]
	segcode_actual = segcode_letter + segcode_number
	segcode_visual = "[" + segcode_actual + "]"
	
	cell_label.text = segcode_visual

func cell_hover(pHover: bool):
	if(pHover):
		vpasp.stream = SoundLibrary.keypress_directional[randi_range(0,8)]
		vpasp.play()
		default_cell_stylebox.bg_color = ConfigGame.main_highlight_color
		default_label_settings.set_font_size(hover_font_size)
	else:
		default_cell_stylebox.bg_color = Color.BLACK
		default_label_settings.set_font_size(default_font_size)

func cell_trail_0():
	pass

func cell_trail_1():
	pass

func _on_area_2d_mouse_entered() -> void:
	#vpasp.stream = SoundLibrary.keypress_directional[randi_range(0,8)]
	#vpasp.play()
	#default_cell_stylebox.bg_color = Color.DARK_SLATE_GRAY
	#default_label_settings.set_font_size(hover_font_size)
	cell_hover(true)

func _on_area_2d_mouse_exited() -> void:
	#default_cell_stylebox.bg_color = Color.BLACK
	#default_label_settings.set_font_size(default_font_size)
	cell_hover(false)


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				vpasp.stream = SoundLibrary.keypress_confirmation[randi_range(0,4)]
				vpasp.play()
				Events.cell_clicked.emit(segcode_actual)
