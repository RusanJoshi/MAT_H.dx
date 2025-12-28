extends Node2D

var dragging: bool = false
var drag_offset:= Vector2i.ZERO
var sensitivity: float = 1.2

func _ready():
	print("main_legacy.gd... loaded")
	#DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
	pass


#func _process(delta):
	#if(Input.is_action_just_pressed("escape_key")):
		#get_tree().quit()
		#print("Program killed.")

#func _input(event):
	#if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_LEFT:
			#if event.pressed:
				#dragging = true
				#drag_offset = event.position
			#else:
				#dragging = false
	#elif event is InputEventMouseMotion and dragging:
		#var new_pos = DisplayServer.window_get_position() + Vector2i(event.relative * sensitivity)
		#DisplayServer.window_set_position(new_pos)
