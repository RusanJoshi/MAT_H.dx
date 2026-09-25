extends Node2D
@export var has_focus: bool
@onready var background: Panel = $Background

func _ready() -> void:
	print("VOLUME WINDOW LOADED!")
	has_focus = true


func kill_window():
	has_focus = false
	self.queue_free()

func _unhandled_input(event): #CLOSES THE WINDOW WHEN CLICKING OUTSIDE
	if(event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed):
		var rect = background.get_global_rect()
		if(!rect.has_point(event.position)):
			kill_window()
			UIManager.global_toggle_pop_up_shade.emit()
