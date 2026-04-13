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

@export var has_focus: bool

var default_visible_wait_time: float = 1.5

var directory_int_x: int = 0
var previous_int_x: int = 0
var directory_int_y: int = 0

var directory_menu: Array[String] = ["extras", "options", "restart", "quit"] #menu
var directory_extras: Array[String] = ["[DELETED]", "customize", "unlocks", "secret"] #extras
var directory_options: Array[String] = ["volume", "difficulty", "detection meter", "crt effect"] #options
var directory_array: Array[Array] = [directory_menu, directory_extras, directory_options]
var dir_path_const: String = "C:\\PERCOM\\MAT_H.dx\\menu"
var dir_path_end: String = "> "
var dir_path_link: String = "\\"
var moption_dir: String = "<DIR> "
var moption_con: String = "<CON>"
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
			if(directory_int_x+1 <= current_dir_x_max):
				menu_traversal(3)
	if(Input.is_action_just_pressed("r_key")): #DEBUG
		volume_moption_target()

func on_first_focus():
	menu_highlights_array[directory_int_y].visible = true
	footer_label.text = cd_into_dir_visual_text(directory_array[directory_int_x][directory_int_y])

func remove_menu_highlights(): # (?)I don't know why, but this executes once before I remember calling it.
	menu_highlights_array[directory_int_y].visible = false
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
	elif(pDirection == 3): #RIGHT
		horizontal_movement = true
		forward = true
	
	footer_label.text = cd_into_dir_visual_text(directory_array[directory_int_x][directory_int_y])
	debug_label.text = str(directory_int_x) + ", " + str(directory_int_y)
	
	if(horizontal_movement):
		play_confirmation_key_sound()
		if(forward):
			print(str(directory_int_x) + ", " + str(directory_int_y))
			moption_functions_array[directory_int_x][directory_int_y].call()
		else: 
			if(directory_int_x-1 < 0):
				print("Can't go further back.")
			else:
				enter_dir(previous_int_x)
				print("<<Going back<<")
	
	footer_label.text = cd_into_dir_visual_text(directory_array[directory_int_x][directory_int_y])
	debug_label.text = str(directory_int_x) + ", " + str(directory_int_y)
	#current_dir_path =
	#header_label.text = 

func cd_into_dir_visual_text(pMenuOption:String):
	var cd_dir_vis: String
	
	cd_dir_vis = dir_path_const + dir_path_end + "cd " + directory_array[directory_int_x][directory_int_y] + " -dir"
	
	return cd_dir_vis

func enter_dir(pDirX: int = 0): #Changes the menu options, the parameter sounds like a condoooom
	previous_int_x = directory_int_x
	directory_int_x = pDirX
	
	menu_option_one_label.text = moption_dir + directory_array[directory_int_x][0]
	menu_option_two_label.text = moption_dir + directory_array[directory_int_x][1]
	menu_option_three_label.text = moption_dir + directory_array[directory_int_x][2]
	menu_option_four_label.text = moption_dir + directory_array[directory_int_x][3]
	
	footer_label.text = cd_into_dir_visual_text(directory_array[directory_int_x][0])

func update_current_dir_path():
	#TODO WIP
	#current_dir_path += dir_path_link + directory_array[directory_int_x][directory_int_y] + 
	pass

func extras_moption_target():
	print("\nExtras...")
	enter_dir(1)
func options_moption_target():
	print("\nOptions...")
	enter_dir(2)
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
	footer_label.text = cd_into_dir_visual_text(directory_array[directory_int_x][directory_int_y])
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
	footer_label.text = cd_into_dir_visual_text(directory_array[directory_int_x][directory_int_y])
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
	footer_label.text = cd_into_dir_visual_text(directory_array[directory_int_x][directory_int_y])
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
	footer_label.text = cd_into_dir_visual_text(directory_array[directory_int_x][directory_int_y])
func _on_menu_option_four_mouse_exited() -> void:
	menu_highlights_array[3].visible = false
func _on_menu_option_four_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				play_confirmation_key_sound()
				moption_functions_array[directory_int_x][directory_int_y].call()
