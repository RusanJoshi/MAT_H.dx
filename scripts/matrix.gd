extends Node2D


@onready var vpasp: VariablePitchAudioStreamPlayer = $VPASP
@onready var left_shell_v_box: VBoxContainer = $FoundationPanel/HBoxContainer/LeftShellPanel/LeftShellVBox
@onready var inside_v_box: VBoxContainer = %InsideVBox
@onready var right_shell_v_box: VBoxContainer = $FoundationPanel/HBoxContainer/RightShellPanel/RightShellVBox
@onready var flash_timer: Timer = $FlashTimer

var occurrence_count_array: Array[Control] # holds occurrence_count objects
var horizontal_partition_array: Array[HBoxContainer] # holds horizontal_partitions (HBoxContainers)
var partitioned_cell_array: Array[Array] # holds arrays of matrix_cell objects
var right_shell_array: Array[Control] # holds right_shell objects

@export var has_focus: bool 
var passkey_full: String = ""
var passkey_actual: String = ""
const PASSKEY_ACTUAL_SIZE: int = 5
var passkey_progress: int = 0

#navigation
var spotlight_cell # current cell hovered over
var previous_cell # previous cell hovered over
var trailing_cell_0
var trailing_cell_1
var current_x_nav: int
var current_y_nav: int

#misc
var game_won: bool = false
var game_lost: bool = false
var game_ended: bool = false
var index_count_hold: int


func _ready():
	print("matrix.gd... loaded")
	Events.cell_clicked.connect(matrix_cell_clicked)
	Events.cipher_ready_to_receive_passkey_actual.connect(send_passkey_actual_to_cipher)
	Events.victory_event.connect(player_victory)
	Events.restart_game.connect(restart)
	Events.lose_event.connect(player_lose)
	
	partition_and_cells_setup()
	passkey_setup()
	occurrence_count_setup()
	occurrence_count_update()
	right_shell_setup()
	matrix_navigation(0,0) #Setting focus on the first matrix cell(0,0)

func _process(delta):
	if(has_focus and !game_ended):
		# Directional Traversal
		if(Input.is_action_just_pressed("up_key")):
			matrix_navigation(0,-1)
		if(Input.is_action_just_pressed("down_key")):
			matrix_navigation(0,1)
		if(Input.is_action_just_pressed("left_key")):
			matrix_navigation(-1,0)
		if(Input.is_action_just_pressed("right_key")):
			matrix_navigation(1,0)
		
		if(Input.is_action_just_pressed("spacebar_key")):
			parity_check(spotlight_cell.segcode_actual)

func partition_and_cells_setup():
	for v_counting in ConfigGame.vertical_dimension:
		# [HORIZONTAL PARTITION] instantiation and initialization
		var horizontal_partition_cartridge = HBoxContainer.new()
		horizontal_partition_array.append(horizontal_partition_cartridge)
		inside_v_box.add_child(horizontal_partition_cartridge)
		horizontal_partition_cartridge.size_flags_vertical = Control.SIZE_EXPAND_FILL
		horizontal_partition_cartridge.add_theme_constant_override("separation", 0)
		var cell_array_cartridge: Array
		partitioned_cell_array.append(cell_array_cartridge)
		
		# [MATRIX CELL] instantiation and initialization
		for h_counting in ConfigGame.horizontal_dimension:
			var matrix_cell_scene = preload("res://matrix/matrix_cell.tscn")
			var matrix_cell_cartridge = matrix_cell_scene.instantiate()
			partitioned_cell_array[v_counting].append(matrix_cell_cartridge)
			horizontal_partition_cartridge.add_child(matrix_cell_cartridge)

func passkey_setup():
	var rng := RandomNumberGenerator.new()
	
	rng.randomize()
	for partition_count in ConfigGame.vertical_dimension:
		passkey_full += partitioned_cell_array[partition_count][rng.randi_range(0, ConfigGame.horizontal_dimension-1)].segcode_actual
	#print(passkey_full)
	for size_count in PASSKEY_ACTUAL_SIZE:
		passkey_actual += passkey_full[rng.randi_range(0,passkey_full.length()-1)]
	#print(passkey_actual)

func occurrence_count_setup():
	for v_counting in ConfigGame.vertical_dimension:
		var occurrence_count_scene = preload("res://matrix/occurrence_count.tscn")
		var occurrence_count_cartridge = occurrence_count_scene.instantiate()
		occurrence_count_array.append(occurrence_count_cartridge)
		left_shell_v_box.add_child(occurrence_count_cartridge)

func occurrence_count_update():
	var occurrence_count: int = 0
	
	for v_counting in ConfigGame.vertical_dimension:
		occurrence_count = 0
		for h_counting in ConfigGame.horizontal_dimension:
			if(partitioned_cell_array[v_counting][h_counting].segcode_actual[0] == passkey_actual[passkey_progress]):
				occurrence_count += 1
			elif(partitioned_cell_array[v_counting][h_counting].segcode_actual[1] == passkey_actual[passkey_progress]):
				occurrence_count += 1
		occurrence_count_array[v_counting].memory_address_setup(str(occurrence_count), true)

func right_shell_setup():
	for v_counting in ConfigGame.vertical_dimension:
		var right_shell_dressing_scene = preload("res://matrix/right_shell_dressing.tscn")
		var right_shell_dressing_cartridge = right_shell_dressing_scene.instantiate()
		right_shell_array.append(right_shell_dressing_cartridge)
		right_shell_v_box.add_child(right_shell_dressing_cartridge)

func matrix_cell_clicked(pSegCode: String):
	parity_check(pSegCode)

func parity_check(pSegCode: String):
	if(pSegCode[0] == passkey_actual[passkey_progress] or pSegCode[1] == passkey_actual[passkey_progress]):
		print(pSegCode + " = " + passkey_actual[passkey_progress])
		vpasp.stream = SoundLibrary.particle_jingle[randi_range(0,6)]
		vpasp.play()
		progress_passkey(pSegCode)
		test_local()
		occurrence_count_update()
		occurrence_count_array[0].correct_flash() # All of them flash. I don't know why.
	else:
		print("no match")
		occurrence_count_array[0].incorrect_flash()
		vpasp.stream = SoundLibrary.incorrect_choice
		vpasp.play()
		Events.progress_detection_meter.emit()

func progress_passkey(pSegCode: String):
	Events.progress_cipher_passkey.emit(pSegCode)
	if(passkey_progress < 4):
		passkey_progress += 1

func send_passkey_actual_to_cipher():
	print("Sending " + passkey_actual)
	Events.update_cipher_repeating_indicator.emit(passkey_actual)

func player_victory():
	game_won = true
	game_ended = true
	#TODO: And then do some animation>>

func restart():
	print("Matrix restarting...")
	horizontal_partition_array.clear()
	partitioned_cell_array.clear()
	passkey_full = ""
	passkey_actual = ""
	passkey_progress = 0
	
	for child in inside_v_box.get_children():
		child.queue_free()
	
	partition_and_cells_setup()
	passkey_setup()
	occurrence_count_update()
	
	current_x_nav = 0
	current_y_nav = 0
	spotlight_cell = partitioned_cell_array[current_x_nav][current_y_nav]
	spotlight_cell.cell_hover(true)
	
	game_won = false
	game_lost = false
	game_ended = false

func player_lose():
	game_lost = true
	game_ended = true
	#TODO: And then do some animation>>

func matrix_navigation(pXNav: int = 0, pYNav: int = 0):
	if(navigation_limit_check(pXNav, pYNav)):
		current_x_nav += pXNav
		current_y_nav += pYNav
		
		previous_cell = spotlight_cell
		if(previous_cell == null):
			print("Nothing")
		else: previous_cell.cell_hover(false)
		spotlight_cell = partitioned_cell_array[current_y_nav][current_x_nav] # new cell at updated coords
		spotlight_cell.cell_hover(true)

func navigation_limit_check(pXNav: int = 0, pYNav: int = 0):
	var x_check: bool = false
	var y_check: bool = false
	
	if(pXNav+current_x_nav >= 0 && pXNav+current_x_nav <= ConfigGame.horizontal_dimension-1):
		x_check = true
	if(pYNav+current_y_nav >= 0 && pYNav+current_y_nav <= ConfigGame.vertical_dimension-1):
		y_check = true
	
	if(x_check && y_check):
		return true
	else: return false

func test_local(): # ex.) prints outs "0x01passkey_actualA1"
	
	pass
