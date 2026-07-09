extends Node2D

@onready var console_panel: Panel = %ConsolePanel

#@onready var cloning_label: Label = $ShinBackground/HBoxContainer/ConsolePanel/CloningLabel
@onready var console_label: Label = %ConsoleLabel
@onready var hx_label: Label = %HXLabel
@onready var vy_label: Label = %VYLabel
@onready var difficulty_level_label: Label = $ShinBackground/DifficultyLevelLabel

@onready var add_x_panel: Panel = %AddXPanel
@onready var min_x_panel: Panel = %MinXPanel
@onready var add_y_panel: Panel = %AddYPanel
@onready var min_y_panel: Panel = %MinYPanel
@onready var save_panel: Panel = %SavePanel
@onready var exit_panel: Panel = %ExitPanel

@export var has_focus: bool

var current_horizontal_dimension: int
var current_vertical_dimension: int
var moption_stylebox: StyleBoxFlat = load("res://ui/moption_highlight_test.tres")
var left_moptions: Array[Panel]
var right_moptions: Array[Panel]
var log_array: Array[Label]
var cloning_label_settings: LabelSettings = LabelSettings.new()

#MENU TRAVERSAL
var menux: int = 0
var menuy: int = 0
var min_menu: int = 0
var max_menu_x: int = 1
var max_menu_y: int = 2
var moptions_array: Array[Array]


func _ready() -> void:
	print("difficulty_window.gd... loaded")
	UIManager.kill_difficulty_window.connect(kill_window)
	
	update_dimensions_from_config()
	
	cloning_label_settings.font = preload("res://fonts/Perfect DOS VGA 437 Win.ttf")
	cloning_label_settings.font_size = 20
	
	#cloning_label.label_settings = cloning_label_settings
	moption_stylebox.bg_color = ConfigGame.cell_highlight_color
	
	left_moptions = [add_x_panel, min_x_panel, save_panel]
	right_moptions = [add_y_panel, min_y_panel, exit_panel]
	moptions_array = [left_moptions, right_moptions]
	
	moptions_array[0][0].visible = true
	has_focus = true

func _process(delta):
	if(has_focus):
		if(Input.is_action_just_pressed("up_key")):
			if(menuy - 1 >= min_menu):
				menu_traversal(0,-1)
		if(Input.is_action_just_pressed("down_key")):
			if(menuy + 1 <= max_menu_y):
				menu_traversal(0,1)
		if(Input.is_action_just_pressed("left_key")):
			if(menux - 1 >= min_menu):
				menu_traversal(-1,0)
		if(Input.is_action_just_pressed("right_key")):
			if(menux + 1 <= max_menu_x):
				menu_traversal(1,0)
		if(Input.is_action_just_pressed("spacebar_key")):
			confirmation()
	
	if(Input.is_action_just_pressed("escape_key")):
		kill_window()
		UIManager.global_toggle_pop_up_window.emit()

func update_dimensions_from_config():
	current_horizontal_dimension = ConfigGame.horizontal_dimension
	current_vertical_dimension = ConfigGame.vertical_dimension
	
	var hx_bracket: String = "[]"
	var vy_bracket: String = "[]"
	hx_label.text = hx_bracket.insert(1, "%02d" % current_horizontal_dimension)
	vy_label.text = vy_bracket.insert(1, "%02d" % current_vertical_dimension)

func update_config_dimensions(pNewHorizontal: int = current_horizontal_dimension, pNewVertical: int = current_vertical_dimension):
	ConfigGame.horizontal_dimension = pNewHorizontal
	ConfigGame.vertical_dimension = pNewVertical

func update_dimensions_labels():
	var hx_bracket: String = "[]"
	var vy_bracket: String = "[]"
	hx_label.text = hx_bracket.insert(1, "%02d" % current_horizontal_dimension)
	vy_label.text = vy_bracket.insert(1, "%02d" % current_vertical_dimension)

func update_console_label():
	var default_text: String = "adj_dif()>>"
	
	if(menux == 0 and menuy == 0):
		console_label.text = default_text.insert(8,"hX++")
	elif(menux == 0 and menuy == 1):
		console_label.text = default_text.insert(8,"hX--")
	elif(menux == 1 and menuy == 0):
		console_label.text = default_text.insert(8,"vY++")
	elif(menux == 1 and menuy == 1):
		console_label.text = default_text.insert(8,"vY--")
	elif(menux == 0 and menuy == 2):
		console_label.text = default_text.insert(8,"save")
	elif(menux == 1 and menuy == 2):
		console_label.text = default_text.insert(8,"exit")

func menu_traversal(pMenuX: int = 0, pMenuY: int = 0):
	var prev_menux = menux
	var prev_menuy = menuy
	menux += pMenuX
	menuy += pMenuY
	moptions_array[prev_menux][prev_menuy].visible = false
	moptions_array[menux][menuy].visible = true
	
	update_console_label()

func confirmation():
	if(menuy == 0):
		if(menux == 0):#INCREASE X-dimension
			increase_x()
		elif(menux == 1):#DECREASE X-dimension
			increase_y()
		update_dimensions_labels()
	elif(menuy == 1):
		if(menux == 0):#INCREASE Y-dimension
			decrease_x()
		elif(menux == 1):#DECREASE Y-dimension
			decrease_y()
		update_dimensions_labels()
	elif(menuy == 2):
		if(menux == 0):#SAVE DIMENSIONS
			save_difficulty()
		elif(menux == 1):#EXIT DIFF. WINDOW
			exit()

func increase_x():
	current_horizontal_dimension += 1
	create_log("X++")
func decrease_x():
	current_horizontal_dimension -= 1
func increase_y():
	current_vertical_dimension += 1
func decrease_y():
	current_vertical_dimension -= 1
func save_difficulty():
	print("saved and updated")
	update_config_dimensions(current_horizontal_dimension, current_vertical_dimension)
func exit():
	kill_window()
	UIManager.global_toggle_pop_up_window.emit()

func create_log(pString):
	var log_cartridge: Label = Label.new()
	var default_text: String = "log: "
	
	log_cartridge.label_settings = cloning_label_settings
	log_cartridge.text = default_text + pString
	if(log_array.size() > 0):
		for index in log_array.size():
			log_array[index].position.y -= console_label.size.y
	log_cartridge.position.y = console_label.position.y - console_label.size.y
	
	log_array.append(log_cartridge)
	console_panel.add_child(log_cartridge)

func kill_window():
	has_focus = false
	self.queue_free()
