extends Control

@onready var debug_label: Label = $DebugLabel
@onready var debug_label_2: Label = $DebugLabel2

var dragging: bool = false
var drag_offset:= Vector2i.ZERO
var sensitivity: float = 1.2
var mouse_in_title_bar: bool = false
var hovering_label: String = ""

func _ready():
	print("custom_window_border.gd... loaded")
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)

#func _process(delta):
	#if(Input.is_action_just_pressed("escape_key")):
		#get_tree().quit()
		#print("Program killed.")
	

func _input(event):
	if(mouse_in_title_bar or dragging):
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT:
				if event.pressed:
					dragging = true
					drag_offset = event.position
				else:
					dragging = false
		elif event is InputEventMouseMotion and dragging:
			var new_pos = DisplayServer.window_get_position() + Vector2i(event.relative * sensitivity)
			DisplayServer.window_set_position(new_pos)

func _on_title_bar_area_2d_mouse_entered() -> void:
	mouse_in_title_bar = true
	debug_label.text = str(mouse_in_title_bar)

func _on_title_bar_area_2d_mouse_exited() -> void:
	mouse_in_title_bar = false
	debug_label.text = str(mouse_in_title_bar)

#MINI
func _on_minimize_button_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				print("MINI")
func _on_minimize_button_area_2d_mouse_entered() -> void:
	debug_label_2.text = "MINI"
func _on_minimize_button_area_2d_mouse_exited() -> void:
	debug_label_2.text = ""

#MAXI
func _on_maximize_button_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				print("MAXI+")
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				print("MAXI")
func _on_maximize_button_area_2d_mouse_entered() -> void:
	debug_label_2.text = "MAXI"
func _on_maximize_button_area_2d_mouse_exited() -> void:
	debug_label_2.text = ""
	
#CLOSE
func _on_close_button_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				get_tree().quit()
				print("Program killed.")
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				print("CLOSE")
func _on_close_button_area_2d_mouse_entered() -> void:
	debug_label_2.text = "CLOSE"
func _on_close_button_area_2d_mouse_exited() -> void:
	debug_label_2.text = ""
