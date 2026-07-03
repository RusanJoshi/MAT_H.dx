extends Node2D

@onready var hx_label: Label = %HXLabel
@onready var vy_label: Label = %VYLabel
@onready var dimensions_label: Label = $ShinBackground/DimensionsLabel
@onready var difficulty_level_label: Label = $ShinBackground/DifficultyLevelLabel

@export var has_focus: bool

var current_horizontal_dimension: int
var current_vertical_dimension: int
var moption_stylebox: StyleBoxFlat = load("res://ui/moption_highlight_test.tres")

#MENU TRAVERSAL
var menux: int = 0
var menuy: int = 0


func _ready() -> void:
	print("difficulty_window.gd... loaded")
	UIManager.kill_difficulty_window.connect(kill_window)
	
	moption_stylebox.bg_color = ConfigGame.cell_highlight_color
	update_dimensions_from_config()
	has_focus = true

func _process(delta):
	if(has_focus):
		if(Input.is_action_just_pressed("up_key")):
			menu_traversal(1,0)
		if(Input.is_action_just_pressed("down_key")):
			menu_traversal(-1,0)
		if(Input.is_action_just_pressed("left_key")):
			menu_traversal(0,-1)
		if(Input.is_action_just_pressed("right_key")):
			menu_traversal(0,1)
	
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
	menux += pMenuX
	menuy += pMenuY
	print(str(menux) + ", " + str(menuy))

func kill_window():
	has_focus = false
	self.queue_free()

#func _on_save_button_pressed() -> void:
	#print("saved and updated")
	#update_config_dimensions(current_horizontal_dimension, current_vertical_dimension)
