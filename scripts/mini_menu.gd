extends Node2D

@onready var cmd_header: HBoxContainer = $VBoxContainer/cmdHeader
@onready var cmd_footer: HBoxContainer = $VBoxContainer/cmdFooter
@onready var header_label: Label = %HeaderLabel
@onready var footer_label: Label = %FooterLabel
@onready var debug_label: Label = $DebugLabel

@onready var blinking_cursor: Label = %BlinkingCursor
@onready var blinking_cursor_timer: Timer = $BlinkingCursorTimer

@onready var menu_option_one_label: Label = %MenuOptionOneLabel
@onready var menu_option_two_label: Label = %MenuOptionTwoLabel
@onready var menu_option_three_label: Label = %MenuOptionThreeLabel
@onready var menu_option_four_label: Label = %MenuOptionFourLabel
@onready var mo_1_highlight: Panel = %MO1Highlight
@onready var mo_2_highlight: Panel = %MO2Highlight
@onready var mo_3_highlight: Panel = %MO3Highlight
@onready var mo_4_highlight: Panel = %MO4Highlight

@export var has_focus: bool

var default_visible_wait_time: float = 1.5

var directory_int_x: int = 0
var directory_int_y: int = 0

var directory_menu: Array[String] = ["extras", "options", "restart", "quit"] #menu
var directory_extras: Array[String] = ["[DELETED]", "customize", "unlocks", "secret"] #extras
var directory_options: Array[String] = ["volume", "difficulty", "detection meter", "crt effect"] #options
var directory_array: Array[Array] = [directory_menu, directory_extras, directory_options]
var dir_path_const: String = "C:\\PERCOM\\MAT_H.dx\\menu"
var dir_path_end: String = "> "
var dir_path_link: String = "\\"
var moption_dir: String = "<DIR> "
var current_dir_path: String = ""
var current_dir_x_min: int = 0
var current_dir_x_max: int = 0
var current_dir_y_min: int = 0 # I believe this will always be zero
var current_dir_y_max: int = 0 # This one changes

var menu_highlights_array: Array[Panel]


func _ready() -> void:
	print("min_menu.gd... loaded")
	blinking_cursor_timer.wait_time = default_visible_wait_time
	menu_highlights_array = [mo_1_highlight, mo_2_highlight, mo_3_highlight, mo_4_highlight]
	
	current_dir_path = dir_path_const
	header_label.text = current_dir_path + dir_path_end + "dir"
	current_dir_x_max = directory_array.size()-1
	current_dir_y_max = directory_array[directory_int_x].size()-1
	enter_dir()

func _process(delta):
	if(has_focus):
		if(Input.is_action_just_pressed("up_key")):
			if(directory_int_y-1 >= current_dir_y_min):
				menu_traversal(0)
		if(Input.is_action_just_pressed("down_key")):
			if(directory_int_y+1 <= current_dir_y_max):
				menu_traversal(1)
		if(Input.is_action_just_pressed("left_key")):
			if(directory_int_x-1 >= current_dir_x_min):
				menu_traversal(2)
		if(Input.is_action_just_pressed("right_key")):
			if(directory_int_x+1 <= current_dir_y_max):
				menu_traversal(3)

func on_first_focus():
	menu_highlights_array[directory_int_y].visible = true
	footer_label.text = cd_into_dir_visual_text(directory_array[directory_int_x][directory_int_y])

func remove_menu_highlights(): # (?)I don't know why, but this executes once before I remember calling it.
	menu_highlights_array[directory_int_y].visible = false
	footer_label.text = current_dir_path + dir_path_end
	directory_int_y = 0

func menu_traversal(pDirection: int = 0):
	#directions 0 = up, 1 = down, 2 = left, 3 = right
	var horizontal_movement: bool = false
	
	if(pDirection == 0): #UP
		directory_int_y -= 1
		menu_highlights_array[directory_int_y+1].visible = false
		menu_highlights_array[directory_int_y].visible = true
	elif(pDirection == 1): #DOWN
		directory_int_y += 1
		menu_highlights_array[directory_int_y-1].visible = false
		menu_highlights_array[directory_int_y].visible = true
	elif(pDirection == 2): #LEFT
		horizontal_movement = true
		directory_int_x -= 1
	elif(pDirection == 3): #RIGHT
		horizontal_movement = true
		directory_int_x += 1
	
	footer_label.text = cd_into_dir_visual_text(directory_array[directory_int_x][directory_int_y])
	debug_label.text = str(directory_int_x) + ", " + str(directory_int_y)
	
	if(horizontal_movement):
		if(directory_int_x == 0):
			print("di: " + str(directory_int_x))
			if(directory_int_y == 0):
				extras_moption_target()
			elif(directory_int_y == 1):
				options_moption_target()
			elif(directory_int_y == 2):
				restart_moption_target()
				Events.restart_game.emit()
			elif(directory_int_y == 3):
				quit_moption_target()
		elif(directory_int_x == 1):
			print("di: " + str(directory_int_x))
			if(directory_int_y == 0):
				print("flag 1")
				pass
			elif(directory_int_y == 1):
				print("flag 2")
				pass
			elif(directory_int_y == 2):
				print("flag 3")
				pass
			elif(directory_int_y == 3):
				print("flag 4")
				pass

func cd_into_dir_visual_text(pMenuOption:String):
	var cd_dir_vis: String
	
	cd_dir_vis = dir_path_const + dir_path_end + "cd " + directory_array[directory_int_x][directory_int_y] + " -dir"
	
	return cd_dir_vis

func enter_dir(pDirX: int = 0): #Changes the menu options, the parameter sounds like a condoooom
	directory_int_x = pDirX
	
	menu_option_one_label.text = moption_dir + directory_array[directory_int_x][0]
	menu_option_two_label.text = moption_dir + directory_array[directory_int_x][1]
	menu_option_three_label.text = moption_dir + directory_array[directory_int_x][2]
	menu_option_four_label.text = moption_dir + directory_array[directory_int_x][3]
	
	footer_label.text = cd_into_dir_visual_text(directory_array[directory_int_x][0])

func exit_dir():
	pass

func extras_moption_target():
	print("\nExtras...")
	enter_dir(1)

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
	directory_int_y = 0
	menu_highlights_array[directory_int_y].visible = true
	footer_label.text = cd_into_dir_visual_text(directory_array[directory_int_x][directory_int_y])
func _on_menu_option_one_mouse_exited() -> void:
	menu_highlights_array[0].visible = false
func _on_menu_option_one_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				extras_moption_target()

#MO2 (MOUSE CLICK)
func _on_menu_option_two_mouse_entered() -> void:
	directory_int_y = 1
	menu_highlights_array[directory_int_y].visible = true
	footer_label.text = cd_into_dir_visual_text(directory_array[directory_int_x][directory_int_y])
func _on_menu_option_two_mouse_exited() -> void:
	menu_highlights_array[1].visible = false
func _on_menu_option_two_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				options_moption_target()

#MO3 (MOUSE CLICK)
func _on_menu_option_three_mouse_entered() -> void:
	directory_int_y = 2
	menu_highlights_array[directory_int_y].visible = true
	footer_label.text = cd_into_dir_visual_text(directory_array[directory_int_x][directory_int_y])
func _on_menu_option_three_mouse_exited() -> void:
	menu_highlights_array[2].visible = false
func _on_menu_option_three_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				restart_moption_target()

#M04 (MOUSE CLICK)
func _on_menu_option_four_mouse_entered() -> void:
	directory_int_y = 3
	menu_highlights_array[directory_int_y].visible = true
	footer_label.text = cd_into_dir_visual_text(directory_array[directory_int_x][directory_int_y])
func _on_menu_option_four_mouse_exited() -> void:
	menu_highlights_array[3].visible = false
func _on_menu_option_four_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				quit_moption_target()
