extends Node2D

@onready var matrix_inside_panel: Panel = %MatrixInsidePanel
@onready var matrix_inside_h_box: HBoxContainer = %MatrixInsideHBox

var vertical_partition_array: Array[VBoxContainer]
var partitioned_cell_array: Array[Array]
var horizontal_size: int = 5 # partition count
var vertical_size: int = 5 # cell count

func _ready():
	create_partitions_and_cells()
	print("matrix_legacy.gd... loaded")

func create_partitions_and_cells():
	var debug_counting: int = 0
	
	for h_counting in horizontal_size:
		# [VERTICAL PARTITION] instantiation and initialization
		var vertical_partition_cartridge = VBoxContainer.new()
		vertical_partition_array.append(vertical_partition_cartridge)
		matrix_inside_h_box.add_child(vertical_partition_cartridge)
		vertical_partition_cartridge.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		vertical_partition_cartridge.add_theme_constant_override("separation", 0)
		var cell_array_cartridge: Array
		partitioned_cell_array.append(cell_array_cartridge)

		# [MATRIX CELL] instantiation and initialization
		for v_counting in vertical_size:
			var matrix_cell_scene = preload("res://matrix/matrix_cell.tscn")
			var matrix_cell_cartridge = matrix_cell_scene.instantiate()
			partitioned_cell_array[h_counting].append(matrix_cell_cartridge)
			vertical_partition_cartridge.add_child(matrix_cell_cartridge)
			debug_counting += 1
	
	#print("Total: " + str(debug_counting))
