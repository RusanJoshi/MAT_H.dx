extends Node2D
@onready var shin_background: Panel = $ShinBackground
@onready var console_panel: Panel = %ConsolePanel
@onready var console_label: Label = %ConsoleLabel
@onready var hx_label: Label = %HXLabel
@onready var vy_label: Label = %VYLabel
@onready var difficulty_level_label: Label = %DifficultyLevelLabel

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
var prev_menux: int
var prev_menuy: int
var min_menu: int = 0
var max_menu_x: int = 1
var max_menu_y: int = 2
var moptions_array: Array[Array]
var broken_chains: bool = false
var x_min_chain: int = 3
var x_max_chain: int = 9
var y_min_chain: int = 3
var y_max_chain: int = 9

#MISC
var nanometer_difficulty_reverse_array: Array[int] = [16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6]


func _ready() -> void:
	print("difficulty_window.gd... loaded")
	UIManager.kill_difficulty_window.connect(kill_window)
	
	update_dimensions_from_config()
	update_difficulty_label()
	
	cloning_label_settings.font = preload("res://fonts/Perfect DOS VGA 437 Win.ttf")
	cloning_label_settings.font_size = 16
	
	moption_stylebox.bg_color = ConfigGame.cell_highlight_color
	
	left_moptions = [add_x_panel, min_x_panel, save_panel]
	right_moptions = [add_y_panel, min_y_panel, exit_panel]
	moptions_array = [left_moptions, right_moptions]
	
	moptions_array[0][0].visible = true
	highlight_dimension_label(1)
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
		UIManager.global_toggle_pop_up_shade.emit()

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

func update_console_label(): #also changes the hx/vy highlight label colors
	var default_text: String = "adj_sett()>>"
	
	if(menux == 0 and menuy == 0):
		console_label.text = default_text.insert(9,"hX++")
		highlight_dimension_label(1)
	elif(menux == 0 and menuy == 1):
		console_label.text = default_text.insert(9,"hX--")
		highlight_dimension_label(1)
	elif(menux == 1 and menuy == 0):
		console_label.text = default_text.insert(9,"vY++")
		highlight_dimension_label(2)
	elif(menux == 1 and menuy == 1):
		console_label.text = default_text.insert(9,"vY--")
		highlight_dimension_label(2)
	elif(menux == 0 and menuy == 2):
		console_label.text = default_text.insert(9,"save")
	elif(menux == 1 and menuy == 2):
		console_label.text = default_text.insert(9,"exit")

func update_dimensions_labels():
	var hx_bracket: String = "[]"
	var vy_bracket: String = "[]"
	hx_label.text = hx_bracket.insert(1, "%02d" % current_horizontal_dimension)
	vy_label.text = vy_bracket.insert(1, "%02d" % current_vertical_dimension)

func update_difficulty_label():
	var nanometer_difficulty: int
	var reversed_difficulty: int
	var reverse_index: int
	
	#print("hDIM: " + str(current_horizontal_dimension) + "\nvDIM: " + str(current_vertical_dimension))
	nanometer_difficulty = (current_horizontal_dimension + current_vertical_dimension)
	if(nanometer_difficulty > 3 and nanometer_difficulty <= 16):
		reverse_index = nanometer_difficulty - 6
		reversed_difficulty = nanometer_difficulty_reverse_array[reverse_index]
	
	if(in_range(reversed_difficulty, 13, 16)):
		difficulty_level_label.text = str(reversed_difficulty) + "nm easy"
	elif(in_range(reversed_difficulty, 9, 12)):
		difficulty_level_label.text = str(reversed_difficulty) + "nm medium"
	elif(in_range(reversed_difficulty, 7, 8)):
		difficulty_level_label.text = str(reversed_difficulty) + "nm hard"
	elif(in_range(reversed_difficulty, 5, 6)):
		difficulty_level_label.text = str(reversed_difficulty) + "nm hardest"
	else:
		difficulty_level_label.text = "?? nm"

func update_hover_highlight(pX: int, pY: int):
	for y_index in right_moptions.size():
		for x_index in left_moptions.size()-1: #Investigate why this is (if you care)
			moptions_array[x_index][y_index].visible = false
	
	moptions_array[pX][pY].visible = true

func menu_traversal(pMenuX: int = 0, pMenuY: int = 0):
	prev_menux = menux
	prev_menuy = menuy
	menux += pMenuX
	menuy += pMenuY
	moptions_array[prev_menux][prev_menuy].visible = false
	moptions_array[menux][menuy].visible = true
	
	update_console_label()

func confirmation(): #[!] also updates difficulty label
	if(menuy == 0):
		if(menux == 0):#INCREASE X-dimension
			increase_x()
		elif(menux == 1):#DECREASE X-dimension
			increase_y()
		update_dimensions_labels()
		dimension_chains()
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
	
	update_difficulty_label()

func increase_x():
	if(current_horizontal_dimension+1 <= x_max_chain):
		current_horizontal_dimension += 1
		create_log("h_X++")
func decrease_x():
	if(current_horizontal_dimension-1 >= x_min_chain):
		current_horizontal_dimension -= 1
		create_log("h_X--")
func increase_y():
	if(current_vertical_dimension+1 <= y_max_chain):
		current_vertical_dimension += 1
		create_log("v_Y++")
func decrease_y():
	if(current_vertical_dimension-1 >= y_min_chain):
		current_vertical_dimension -= 1
		create_log("v_Y--")
func save_difficulty():
	print("saved and updated")
	update_config_dimensions(current_horizontal_dimension, current_vertical_dimension)
func exit():
	kill_window()
	UIManager.global_toggle_pop_up_shade.emit()

func create_log(pString):
	var log_cartridge: Label = Label.new()
	var default_text: String = "upd_log: "
	
	log_cartridge.label_settings = cloning_label_settings
	log_cartridge.text = default_text + pString
	if(log_array.size() > 0):
		for index in log_array.size():
			log_array[index].position.y -= console_label.size.y
	log_cartridge.position.y = console_label.position.y - console_label.size.y
	
	log_array.append(log_cartridge)
	console_panel.add_child(log_cartridge)
	if(log_array.size() > 10):
		log_array[0].queue_free()
		log_array.remove_at(0)

func highlight_dimension_label(pLabel: int = 0):
	if(pLabel == 1):
		hx_label.modulate = Color.RED
		vy_label.modulate = Color.WHITE
	elif(pLabel == 2):
		vy_label.modulate = Color.RED
		hx_label.modulate = Color.WHITE
	else:
		hx_label.modulate = Color.WHITE
		vy_label.modulate = Color.WHITE

func in_range(pValue: int, pMinRange: int, pMaxRange: int) -> bool:
	return pMaxRange >= pValue and pValue >= pMinRange

func dimension_chains():
	#the intention is to create a minimum limit of 3x3 and maximum of 7x9/9x7
	if(current_horizontal_dimension == 9):
		print("[DEBUG, dimension_chains(), IF-S-1]")
		y_max_chain = 7
	elif(current_vertical_dimension == 9):
		print("[DEBUG, dimension_chains(), ELIF-S-2]")
		x_max_chain = 7
	else:
		print("[DEBUG, dimension_chains(), ELSE-S-3]")
		x_max_chain = 9
		y_max_chain = 9

func kill_window():
	print("x: " + str(current_horizontal_dimension) + ", y: " + str(current_vertical_dimension))
	has_focus = false
	self.queue_free()

func _unhandled_input(event): #CLOSES THE WINDOW WHEN CLICKING OUTSIDE
	if(event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed):
		var rect = shin_background.get_global_rect()
		if(!rect.has_point(event.position)):
			kill_window()
			UIManager.global_toggle_pop_up_shade.emit()

#MOUSE CONROLS // MOUSE CONTROLS // MOUSE CONTROLS // MOUSE CONTROLS // MOUSE CONTROLS
#ADD X
func _on_add_x_area_2d_mouse_entered() -> void:
	prev_menux = menux
	prev_menuy = menuy
	menux = 0
	menuy = 0
	update_hover_highlight(menux, menuy)
	highlight_dimension_label(1)
func _on_add_x_area_2d_mouse_exited() -> void:
	pass
func _on_add_x_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				confirmation()

#MIN X
func _on_min_x_area_2d_mouse_entered() -> void:
	prev_menux = menux
	prev_menuy = menuy
	menux = 0
	menuy = 1
	update_hover_highlight(menux, menuy)
	highlight_dimension_label(1)
func _on_min_x_area_2d_mouse_exited() -> void:
	pass
func _on_min_x_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				confirmation()

#ADD Y
func _on_add_y_area_2d_mouse_entered() -> void:
	prev_menux = menux
	prev_menuy = menuy
	menux = 1
	menuy = 0
	update_hover_highlight(menux, menuy)
	highlight_dimension_label(2)
func _on_add_y_area_2d_mouse_exited() -> void:
	pass
func _on_add_y_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				confirmation()

#MIN Y
func _on_min_y_area_2d_mouse_entered() -> void:
	prev_menux = menux
	prev_menuy = menuy
	menux = 1
	menuy = 1
	update_hover_highlight(menux, menuy)
	highlight_dimension_label(2)
func _on_min_y_area_2d_mouse_exited() -> void:
	pass
func _on_min_y_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				confirmation()

#SAVE
func _on_save_area_2d_mouse_entered() -> void:
	prev_menux = menux
	prev_menuy = menuy
	menux = 0
	menuy = 2
	update_hover_highlight(menux, menuy)
func _on_save_area_2d_mouse_exited() -> void:
	pass
func _on_save_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				confirmation()

#EXIT
func _on_exit_area_2d_mouse_entered() -> void:
	prev_menux = menux
	prev_menuy = menuy
	menux = 1
	menuy = 2
	update_hover_highlight(menux, menuy)
func _on_exit_area_2d_mouse_exited() -> void:
	pass
func _on_exit_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				confirmation()
