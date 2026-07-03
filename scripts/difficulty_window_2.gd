extends Node2D

@onready var hx_label: Label = %HXLabel
@onready var vy_label: Label = %VYLabel
@onready var dimensions_label: Label = $ShinBackground/DimensionsLabel
@onready var difficulty_level_label: Label = $ShinBackground/DifficultyLevelLabel

var current_horizontal_dimension: int
var current_vertical_dimension: int

func _ready() -> void:
	print("difficulty_window.gd... loaded")
	UIManager.kill_difficulty_window.connect(kill_window)
	
	update_dimensions_from_config()

func update_dimensions_from_config():
	current_horizontal_dimension = ConfigGame.horizontal_dimension
	current_vertical_dimension = ConfigGame.vertical_dimension
	
	hx_label.text = "%02d" % current_horizontal_dimension
	vy_label.text = "%02d" % current_vertical_dimension
	update_dimensions_label(current_horizontal_dimension, current_vertical_dimension)

func update_config_dimensions(pNewHorizontal: int = current_horizontal_dimension, pNewVertical: int = current_vertical_dimension):
	ConfigGame.horizontal_dimension = pNewHorizontal
	ConfigGame.vertical_dimension = pNewVertical

func update_dimensions_label(pX : int, pY : int):
	dimensions_label.text = str(pX) + "x" + str(pY)

func kill_window():
	self.queue_free()

func _on_hx_left_button_pressed() -> void:
	current_horizontal_dimension -= 1
	hx_label.text = "%02d" % current_horizontal_dimension
	update_dimensions_label(current_horizontal_dimension, current_vertical_dimension)
func _on_hx_right_button_pressed() -> void:
	current_horizontal_dimension += 1
	hx_label.text = "%02d" % current_horizontal_dimension
	update_dimensions_label(current_horizontal_dimension, current_vertical_dimension)
	
func _on_vy_up_button_pressed() -> void:
	current_vertical_dimension += 1
	vy_label.text = "%02d" % current_vertical_dimension
	update_dimensions_label(current_horizontal_dimension, current_vertical_dimension)
func _on_vy_down_button_pressed() -> void:
	current_vertical_dimension -= 1
	vy_label.text = "%02d" % current_vertical_dimension
	update_dimensions_label(current_horizontal_dimension, current_vertical_dimension)
	
func _on_save_button_pressed() -> void:
	print("saved and updated")
	update_config_dimensions(current_horizontal_dimension, current_vertical_dimension)
