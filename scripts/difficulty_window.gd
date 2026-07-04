extends Node2D

@onready var hx_label: Label = %HXLabel
@onready var vy_label: Label = %VYLabel
@onready var difficulty_level_label: Label = $ShinBackground/DifficultyLevelLabel

@onready var add_x_panel: Panel = %AddXPanel
@onready var min_x_panel: Panel = %MinXPanel
@onready var add_y_panel: Panel = %AddYPanel
@onready var min_y_panel: Panel = %MinYPanel
@onready var save_panel: Panel = %SavePanel
@onready var restart_panel: Panel = %RestartPanel

@export var has_focus: bool

var current_horizontal_dimension: int
var current_vertical_dimension: int
var moption_stylebox: StyleBoxFlat = load("res://ui/moption_highlight_test.tres")
var left_moptions: Array[Panel]
var right_moptions: Array[Panel]

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
	
	#update_dimensions_from_config()
	moption_stylebox.bg_color = ConfigGame.cell_highlight_color
	left_moptions = [add_x_panel, min_x_panel, save_panel]
	right_moptions = [add_y_panel, min_y_panel, restart_panel]
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
	
	hx_label.text = "%02d" % current_horizontal_dimension
	vy_label.text = "%02d" % current_vertical_dimension

func update_config_dimensions(pNewHorizontal: int = current_horizontal_dimension, pNewVertical: int = current_vertical_dimension):
	ConfigGame.horizontal_dimension = pNewHorizontal
	ConfigGame.vertical_dimension = pNewVertical

func menu_traversal(pMenuX: int = 0, pMenuY: int = 0):
	var prev_menux = menux
	var prev_menuy = menuy
	menux += pMenuX
	menuy += pMenuY
	moptions_array[prev_menux][prev_menuy].visible = false
	moptions_array[menux][menuy].visible = true

func confirmation():
	if(menuy == 0):
		if(menux == 0):
			increase_x()
		elif(menux == 1):
			increase_y()
	elif(menuy == 1):
		if(menux == 0):
			decrease_x()
		elif(menux == 1):
			decrease_y()
	elif(menuy == 2):
		if(menux == 0):
			save_difficulty()
		elif(menux == 1):
			restart()

func increase_x():
	print("X++")
func decrease_x():
	print("X--")
func increase_y():
	print("Y++")
func decrease_y():
	print("Y--")
func save_difficulty():
	print("saved and updated")
	update_config_dimensions(current_horizontal_dimension, current_vertical_dimension)
func restart():
	print("RESTART")




func kill_window():
	has_focus = false
	self.queue_free()
