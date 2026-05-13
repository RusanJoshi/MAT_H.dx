extends Node2D

@onready var vpasp: VariablePitchAudioStreamPlayer = $VPASP
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
@onready var rb_highlight: Panel = $ReturnButtonLabel/RBHighlight
var moption_stylebox: StyleBoxFlat = load("res://ui/moption_highlight_test.tres")

@export var has_focus: bool

var default_visible_wait_time: float = 1.5

var directory_int_x: int = 0
var previous_int_x: int = 0
var directory_int_y: int = 0

var directory_menu: Array[String] = ["extras", "options", "restart", "quit"] #menu
var directory_extras: Array[String] = ["[DELETED]", "customize", "unlocks", "secret"] #extras
var directory_options: Array[String] = ["volume", "difficulty", "detection meter", "crt effect"] #options
var directory_array: Array[Array] = [directory_menu, directory_extras, directory_options]
var directory_path_array: Array[String]
var DIR_PATH_CONST: String = "C:\\PERCOM\\MAT_H.dx\\menu"
var DIR_PATH_FOOTER_CONST: String = "C:\\..\\MAT_H.dx\\menu"
var pre_header_label_text: String = ""
var dir_path_end: String = "> "
var dir_path_link: String = "\\"
var entered_dir: String = ""
var moption_dir: String = "<DIR> "
var moption_app: String = "<APP> "
var moption_action: String = ""
var moption_tag_arrangement_one: Array[String] = [
	moption_dir, moption_dir, moption_app, moption_app]
var moption_tag_arrangement_two: Array[String] = [
	moption_app, moption_app,moption_app, moption_app]
var moption_tag_array_cartridge: Array[String]
var current_dir_path: String = ""
var current_dir_x_min: int = 0
var current_dir_x_max: int = 0
var current_dir_y_min: int = 0 # I believe this will always be zero
var current_dir_y_max: int = 0 # This one changes
var menu_highlights_array: Array[Panel]

var menu_moption_functions: Array[Callable] = [
	extras_moption_target,
	options_moption_target,
	restart_moption_target,
	quit_moption_target
]
var extras_moption_functions: Array[Callable] = [
	deleted_moption_target,
	customize_moption_target,
	unlocks_moption_target,
	secrets_moption_target
]
var options_moption_functions: Array[Callable] = [
	volume_moption_target,
	difficulty_moption_target,
	detection_meter_moption_target,
	crt_effect_moption_target
]
var moption_functions_array: Array[Array] = [
	menu_moption_functions,
	extras_moption_functions,
	options_moption_functions
]


func _ready() -> void:
	print("min_menu.gd... loaded")
	blinking_cursor_timer.wait_time = default_visible_wait_time
	menu_highlights_array = [mo_1_highlight, mo_2_highlight, mo_3_highlight, mo_4_highlight]
	directory_path_array.append(DIR_PATH_CONST)
	current_dir_path = directory_path_array[0]
	pre_header_label_text = directory_path_array[0]
	header_label.text = current_dir_path + dir_path_end + "dir"
	current_dir_x_max = directory_array.size()
	current_dir_y_max = directory_array[directory_int_x].size()-1
	enter_dir()

func _process(delta):
	#debug_label.text = str(directory_int_x) + ", " + str(directory_int_y)
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
			if(directory_int_x+1 <= current_dir_x_max):
				menu_traversal(3)
			else: print(str(directory_int_x+1) + " : " + str(current_dir_x_max))
	if(Input.is_action_just_pressed("r_key")): #DEBUG
		pass

func on_first_focus():
	menu_highlights_array[directory_int_y].visible = true
	footer_label.text = update_footer_text()

func remove_menu_highlights(): #Also adjust the moption highlight colors
	menu_highlights_array[directory_int_y].visible = false
	moption_stylebox.bg_color = ConfigGame.cell_highlight_color
	footer_label.text = current_dir_path + dir_path_end
	directory_int_y = 0

func menu_traversal(pDirection: int = 0):
	#directions: (0 = up), (1 = down), (2 = left), (3 = right)
	var horizontal_movement: bool = false
	var forward: bool = false
	var previous: bool = false
	var horizontal_direction: int = 0
	
	play_directional_key_sound()
	
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
		update_current_dir_path(false)
	elif(pDirection == 3): #RIGHT
		horizontal_movement = true
		forward = true
	
	if(horizontal_movement):
		play_confirmation_key_sound()
		if(forward):
			moption_functions_array[directory_int_x][directory_int_y].call()
		else: 
			if(directory_int_x-1 < 0):
				print("Can't go further back.")
			else:
				enter_dir(previous_int_x)
				print("<<Going back<<")
	
	footer_label.text = update_footer_text()

func update_footer_text():
	var cd_dir_vis: String
	var cd_action: String
	
	cd_dir_vis = pre_header_label_text + dir_path_end + "cd " + directory_array[directory_int_x][directory_int_y] + " -dir"
	
	return cd_dir_vis

func enter_dir(pDirX: int = 0, pTag: bool = false): #Changes the menu options, the parameter sounds like a condoooom
	previous_int_x = directory_int_x
	directory_int_x = pDirX
	
	if(pTag):
		moption_tag_array_cartridge = moption_tag_arrangement_two
	else: moption_tag_array_cartridge = moption_tag_arrangement_one
	
	menu_option_one_label.text = moption_tag_array_cartridge[0] + directory_array[directory_int_x][0]
	menu_option_two_label.text = moption_tag_array_cartridge[1] + directory_array[directory_int_x][1]
	menu_option_three_label.text = moption_tag_array_cartridge[2] + directory_array[directory_int_x][2]
	menu_option_four_label.text = moption_tag_array_cartridge[3] + directory_array[directory_int_x][3]
	
	footer_label.text = update_footer_text()

func update_current_dir_path(pForward: bool = false):
	var new_path: String
	var current_last_index: int = directory_path_array.size()-1
	
	if(pForward):
		if(entered_dir != directory_array[0][directory_int_y]):
			entered_dir = directory_array[0][directory_int_y]
			new_path = directory_path_array[current_last_index] + dir_path_link + entered_dir
			directory_path_array.append(new_path)
			pre_header_label_text = new_path
			header_label.text = new_path + dir_path_end + "dir"
	else:
		entered_dir = ""
		directory_path_array.remove_at(current_last_index)
		current_last_index = directory_path_array.size()-1
		pre_header_label_text = directory_path_array[current_last_index]
		header_label.text = directory_path_array[current_last_index] + dir_path_end + "dir"

func extras_moption_target():
	print("\nExtras...")
	enter_dir(1,1)
	update_current_dir_path(true)
func options_moption_target():
	print("\nOptions...")
	enter_dir(2,1)
	update_current_dir_path(true)
func restart_moption_target():
	print("\nRestarting...")
	Events.restart_game.emit()
func quit_moption_target():
	print("\nQuit...")
	get_tree().quit()

func deleted_moption_target():
	print("\nInvalid...")
func customize_moption_target():
	print("\nCustomize...")
func unlocks_moption_target():
	print("\nUnlocks...")
func secrets_moption_target():
	print("\nSecrets...")

func volume_moption_target():
	print("\nVolume...")
func difficulty_moption_target():
	print("\nDifficulty...")
func detection_meter_moption_target():
	print("\nDetection Meter...")
func crt_effect_moption_target():
	print("\nCRT Effect...")

func _on_blinking_cursor_timer_timeout() -> void:
	if(blinking_cursor.is_visible_in_tree()):
		blinking_cursor_timer.wait_time = default_visible_wait_time
	else:
		blinking_cursor_timer.wait_time = 0.7
	
	blinking_cursor.visible = !blinking_cursor.is_visible_in_tree()

func play_directional_key_sound():
	vpasp.stream = SoundLibrary.keypress_directional[randi_range(0,7)]
	vpasp.play()

func play_confirmation_key_sound():
	vpasp.stream = SoundLibrary.keypress_confirmation[randi_range(0,4)]
	vpasp.play()

#MO1 (MOUSE CLICK)
func _on_menu_option_one_mouse_entered() -> void:
	play_directional_key_sound()
	directory_int_y = 0
	menu_highlights_array[directory_int_y].visible = true
	footer_label.text = update_footer_text()
func _on_menu_option_one_mouse_exited() -> void:
	menu_highlights_array[0].visible = false
func _on_menu_option_one_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				play_confirmation_key_sound()
				moption_functions_array[directory_int_x][directory_int_y].call()

#MO2 (MOUSE CLICK)
func _on_menu_option_two_mouse_entered() -> void:
	play_directional_key_sound()
	directory_int_y = 1
	menu_highlights_array[directory_int_y].visible = true
	footer_label.text = update_footer_text()
func _on_menu_option_two_mouse_exited() -> void:
	menu_highlights_array[1].visible = false
func _on_menu_option_two_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				play_confirmation_key_sound()
				moption_functions_array[directory_int_x][directory_int_y].call()

#MO3 (MOUSE CLICK)
func _on_menu_option_three_mouse_entered() -> void:
	play_directional_key_sound()
	directory_int_y = 2
	menu_highlights_array[directory_int_y].visible = true
	footer_label.text = update_footer_text()
func _on_menu_option_three_mouse_exited() -> void:
	menu_highlights_array[2].visible = false
func _on_menu_option_three_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				play_confirmation_key_sound()
				moption_functions_array[directory_int_x][directory_int_y].call()

#M04 (MOUSE CLICK)
func _on_menu_option_four_mouse_entered() -> void:
	play_directional_key_sound()
	directory_int_y = 3
	menu_highlights_array[directory_int_y].visible = true
	footer_label.text = update_footer_text()
func _on_menu_option_four_mouse_exited() -> void:
	menu_highlights_array[3].visible = false
func _on_menu_option_four_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				play_confirmation_key_sound()
				moption_functions_array[directory_int_x][directory_int_y].call()

#RETURN BUTTON
func _on_return_button_area_2d_mouse_entered() -> void:
	rb_highlight.visible = true
	#clear other highlights
	menu_highlights_array[0].visible = false
	menu_highlights_array[1].visible = false
	menu_highlights_array[2].visible = false
	menu_highlights_array[3].visible = false
func _on_return_button_area_2d_mouse_exited() -> void:
	rb_highlight.visible = false
func _on_return_button_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				play_confirmation_key_sound()
				if(directory_int_x > 0):
					menu_traversal(2)
