extends Node2D
#Notes:
# vertical_dimension == horizontal_partition_array.size()
@onready var vpasp: VariablePitchAudioStreamPlayer = $VPASP
@onready var left_shell_v_box: VBoxContainer = $FoundationPanel/HBoxContainer/LeftShellPanel/LeftShellVBox
@onready var inside_v_box: VBoxContainer = %InsideVBox
@onready var right_shell_v_box: VBoxContainer = $FoundationPanel/HBoxContainer/RightShellPanel/RightShellVBox

var occurrence_count_array: Array[Control] # holds occurrence_count objects
var horizontal_partition_array: Array[HBoxContainer] # holds horizontal_partitions (HBoxContainers)
var partitioned_cell_array: Array[Array] # holds arrays of matrix_cell objects
var right_shell_array: Array[Control] # holds right_shell objects

@export var has_focus: bool 
var passkey_full: String = ""
var passkey_actual: String = ""
const PASSKEY_ACTUAL_SIZE: int = 5
var passkey_progress: int = 0

#temp vars for testing
var temp_rng := RandomNumberGenerator.new() #TODO: Delete later
var spotlight_cell

func _ready():
	print("matrix.gd... loaded")
	Events.cell_clicked.connect(matrix_cell_clicked)
	Events.cipher_ready_to_receive_passkey_actual.connect(send_passkey_actual_to_cipher)
	Events.victory_event.connect(player_victory)
	Events.restart_game.connect(restart)
	
	partition_and_cells_setup()
	passkey_setup()
	occurrence_count_setup()
	occurrence_count_update()
	right_shell_setup()

func _process(delta):
	if(has_focus):
		if(Input.is_action_just_pressed("up_key")):
			#horizontal_partition_array[temp_rng.randi_range(0, ConfigGame.horizontal_dimension-1)]
			spotlight_cell = partitioned_cell_array[temp_rng.randi_range(0, ConfigGame.horizontal_dimension-1)][temp_rng.randi_range(0, ConfigGame.horizontal_dimension-1)]
			spotlight_cell.cell_hover(true)
		if(Input.is_action_just_pressed("down_key")):
			pass
		if(Input.is_action_just_pressed("left_key")):
			pass
		if(Input.is_action_just_pressed("right_key")):
			pass

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
	else:
		print("no match")
		Events.progress_detection_meter.emit()

func progress_passkey(pSegCode: String):
	Events.progress_cipher_passkey.emit(pSegCode)
	if(passkey_progress < 4):
		passkey_progress += 1

func send_passkey_actual_to_cipher():
	print("Sending " + passkey_actual)
	Events.update_cipher_repeating_indicator.emit(passkey_actual)

func player_victory():
	print("Congratulations, bitch.")

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

func test_local(): # ex.) prints outs "0x01passkey_actualA1"
	
	pass
