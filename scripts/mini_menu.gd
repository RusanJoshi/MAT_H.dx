extends Node2D

@onready var cmd_header: HBoxContainer = $VBoxContainer/cmdHeader
@onready var cmd_footer: HBoxContainer = $VBoxContainer/cmdFooter
@onready var header_label: Label = %HeaderLabel
@onready var footer_label: Label = %FooterLabel
@onready var blinking_cursor: Label = %BlinkingCursor
@onready var blinking_cursor_timer: Timer = $BlinkingCursorTimer
@onready var mo_1_highlight: Panel = %MO1Highlight
@onready var mo_2_highlight: Panel = %MO2Highlight
@onready var mo_3_highlight: Panel = %MO3Highlight
@onready var mo_4_highlight: Panel = %MO4Highlight

@export var has_focus: bool
var default_visible_wait_time: float = 1.5

#SHIN>
var directory_int_x: int = 0
var directory_int_y: int = 0

var directory_menu: Array[String] = ["extras", "options", "restart", "quit"] #menu
var directory_extras: Array[String] = ["shop", "customize", "unlocks", "secret"] #extras
var directory_options: Array[String] = ["volume", "difficulty", "detection meter", "crt effect"] #options
var directory_array: Array[Array] = [directory_menu, directory_extras, directory_options]
var dir_path_const: String = "C:\\PERCOM\\MAT_H.dx\\menu--"
var dir_path_end: String = ">"
var dir_path_link: String = "\\"
var current_dir_path: String = ""
var current_dir_min: int = 0 # I believe this will always be zero
var current_dir_max: int = 0 # This one changes
#<SHIN

#var menu_list_array: Array[String] = [
	#"C:\\PERCOM\\MAT_H.dx\\menu> cd extras -dir",
	#"C:\\PERCOM\\MAT_H.dx\\menu> cd options -dir",
	#"C:\\PERCOM\\MAT_H.dx\\menu> cd restart -dir",
	#"C:\\PERCOM\\MAT_H.dx\\menu> cd quit -dir"
#]
#var default_menu_path = "C:\\PERCOM\\MAT_H.dx\\menu>"
#var menu_list_location_int: int = -1
#var location_min_range = 0
#var location_max_range = 3
var menu_highlights_array: Array[Panel]


func _ready() -> void:
	print("min_menu.gd... loaded")
	blinking_cursor_timer.wait_time = default_visible_wait_time
	menu_highlights_array = [mo_1_highlight, mo_2_highlight, mo_3_highlight, mo_4_highlight]
	
	current_dir_path = dir_path_const
	header_label.text = current_dir_path + dir_path_end
	current_dir_max = directory_array[directory_int_x].size()-1

#func _process(delta):
	#if(has_focus):
		#if(Input.is_action_just_pressed("spacebar_key")):
			#if(menu_list_location_int == 0):
				#extras_moption_target()
			#elif(menu_list_location_int == 1):
				#options_moption_target()
			#elif(menu_list_location_int == 2):
				#restart_moption_target()
				#Events.restart_game.emit()
			#elif(menu_list_location_int == 3):
				#quit_moption_target()
		#if(Input.is_action_just_pressed("up_key")):
			#if(menu_list_location_int-1 >= location_min_range):
				#menu_list_location_int -= 1
				#menu_highlights_array[menu_list_location_int+1].visible = false
				#menu_highlights_array[menu_list_location_int].visible = true
				#footer_label.text = menu_list_array[menu_list_location_int]
		#if(Input.is_action_just_pressed("down_key")):
			#if(menu_list_location_int+1 <= location_max_range):
				#menu_list_location_int += 1
				#menu_highlights_array[menu_list_location_int-1].visible = false
				#menu_highlights_array[menu_list_location_int].visible = true
				#footer_label.text = menu_list_array[menu_list_location_int]

func _process(delta): #SHIN
	if(has_focus):
		if(Input.is_action_just_pressed("right_key")):
			if(directory_int_y == 0):
				extras_moption_target()
			elif(directory_int_y == 1):
				options_moption_target()
			elif(directory_int_y == 2):
				restart_moption_target()
				Events.restart_game.emit()
			elif(directory_int_y == 3):
				quit_moption_target()
		if(Input.is_action_just_pressed("up_key")):
			if(directory_int_y-1 >= current_dir_min):
				directory_int_y -= 1
				menu_highlights_array[directory_int_y+1].visible = false
				menu_highlights_array[directory_int_y].visible = true
				footer_label.text = cd_into_dir(directory_array[directory_int_x][directory_int_y])
		if(Input.is_action_just_pressed("down_key")):
			if(directory_int_y+1 <= current_dir_max):
				directory_int_y += 1
				menu_highlights_array[directory_int_y-1].visible = false
				menu_highlights_array[directory_int_y].visible = true
				footer_label.text = dir_path_const + directory_array[directory_int_x][directory_int_y]

func menu_path_string_adjustment():
	#current_dir_path = current_dir_path.insert(current_dir_path.length()-1, dir_path_link + directory_menu[directory_int_y])
	#print(current_dir_path)
	pass

func cd_into_dir(pMenuOption:String):
	var cd_dir: String
	
	cd_dir = current_dir_path
	
	return cd_dir

func on_first_focus():
	menu_highlights_array[directory_int_y].visible = true
	footer_label.text = dir_path_const + dir_path_link + directory_array[directory_int_x][directory_int_y]

func remove_menu_highlights(): # (?)I don't know why, but this executes once before I remember calling it.
	menu_highlights_array[directory_int_y].visible = false
	footer_label.text = current_dir_path + "chacha"
	directory_int_y = 0

func extras_moption_target():
	print("\nExtras...")

func restart_moption_target():
	print("\nRestarting...")
	Events.restart_game.emit()

func options_moption_target():
	print("\nOptions...")

func quit_moption_target():
	print("\nQuit...")
	get_tree().quit()

func _on_blinking_cursor_timer_timeout() -> void:
	if(blinking_cursor.is_visible_in_tree()):
		blinking_cursor_timer.wait_time = default_visible_wait_time
	else:
		blinking_cursor_timer.wait_time = 0.7
	
	blinking_cursor.visible = !blinking_cursor.is_visible_in_tree()

#MO1 (MOUSE CLICK)
func _on_menu_option_one_mouse_entered() -> void:
	menu_highlights_array[0].visible = true
	footer_label.text = dir_path_const + directory_array[directory_int_x][directory_int_y]
func _on_menu_option_one_mouse_exited() -> void:
	menu_highlights_array[0].visible = false
func _on_menu_option_one_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				extras_moption_target()

#MO2 (MOUSE CLICK)
func _on_menu_option_two_mouse_entered() -> void:
	menu_highlights_array[1].visible = true
	footer_label.text = dir_path_const + directory_array[directory_int_x][directory_int_y]
func _on_menu_option_two_mouse_exited() -> void:
	menu_highlights_array[1].visible = false
func _on_menu_option_two_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				options_moption_target()

#MO3 (MOUSE CLICK)
func _on_menu_option_three_mouse_entered() -> void:
	menu_highlights_array[2].visible = true
	footer_label.text = dir_path_const + directory_array[directory_int_x][directory_int_y]
func _on_menu_option_three_mouse_exited() -> void:
	menu_highlights_array[2].visible = false
func _on_menu_option_three_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				restart_moption_target()

#M04 (MOUSE CLICK)
func _on_menu_option_four_mouse_entered() -> void:
	menu_highlights_array[3].visible = true
	footer_label.text = dir_path_const + directory_array[directory_int_x][directory_int_y]
func _on_menu_option_four_mouse_exited() -> void:
	menu_highlights_array[3].visible = false
func _on_menu_option_four_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				quit_moption_target()
