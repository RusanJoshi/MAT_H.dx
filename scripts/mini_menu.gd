extends Node2D

@onready var cmd_header: HBoxContainer = $VBoxContainer/cmdHeader
@onready var cmd_footer: HBoxContainer = $VBoxContainer/cmdFooter
@onready var footer_label: Label = %FooterLabel
@onready var blinking_cursor: Label = %BlinkingCursor
@onready var blinking_cursor_timer: Timer = $BlinkingCursorTimer
@onready var mo_1_highlight: Panel = %MO1Highlight
@onready var mo_2_highlight: Panel = %MO2Highlight
@onready var mo_3_highlight: Panel = %MO3Highlight

@export var has_focus: bool
var default_visible_wait_time: float = 1.5
var directory_one: String = "menu"
var directory_two: String = ""
var menu_list_array: Array[String] = [
	"C:\\PERCOM\\MAT_H.dx\\" + directory_one + "> cd restart -dir",
	"C:\\PERCOM\\MAT_H.dx\\" + directory_one + "> cd options -dir",
	"C:\\PERCOM\\MAT_H.dx\\" + directory_one + "> cd quit -dir"
]
var menu_list_location_int: int = -1
var location_min_range = 0
var location_max_range = 2
var menu_highlights_array: Array[Panel]


func _ready() -> void:
	print("min_menu.gd... loaded")
	blinking_cursor_timer.wait_time = default_visible_wait_time
	menu_highlights_array = [mo_1_highlight, mo_2_highlight, mo_3_highlight]

func _process(delta):
	if(has_focus):
		if(Input.is_action_just_pressed("spacebar_key")):
			if(menu_list_location_int == 0):
				print("\nRestarting...")
				Events.restart_game.emit()
			elif(menu_list_location_int == 1):
				print("\nOptions...")
			elif(menu_list_location_int == 2):
				print("\nQuit...")
		if(Input.is_action_just_pressed("up_key")):
			if(menu_list_location_int-1 >= location_min_range):
				menu_list_location_int -= 1
				menu_highlights_array[menu_list_location_int+1].visible = false
				menu_highlights_array[menu_list_location_int].visible = true
				footer_label.text = menu_list_array[menu_list_location_int]
		if(Input.is_action_just_pressed("down_key")):
			if(menu_list_location_int+1 <= location_max_range):
				menu_list_location_int += 1
				menu_highlights_array[menu_list_location_int-1].visible = false
				menu_highlights_array[menu_list_location_int].visible = true
				footer_label.text = menu_list_array[menu_list_location_int]

func change_highlight_color():
	
	pass

func _on_blinking_cursor_timer_timeout() -> void:
	if(blinking_cursor.is_visible_in_tree()):
		blinking_cursor_timer.wait_time = default_visible_wait_time
	else:
		blinking_cursor_timer.wait_time = 0.7
	
	blinking_cursor.visible = !blinking_cursor.is_visible_in_tree()
