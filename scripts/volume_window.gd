extends Node2D
@export var has_focus: bool
@onready var background: Panel = $Background
@onready var m_volume_rocker: Node2D = $MasterLabel/MVolumeRocker
@onready var kp_volume_rocker: Node2D = $KeyPressLabel/KPVolumeRocker
@onready var j_volume_rocker: Node2D = $JinglesLabel/JVolumeRocker

func _ready() -> void:
	print("volume_window.gd... loaded")
	has_focus = true
	
	pass_volume_levels()

func pass_volume_levels():
	m_volume_rocker.assign_volume_level(ConfigGame.master_volume_level)
	kp_volume_rocker.assign_volume_level(ConfigGame.keypress_volume_level)
	j_volume_rocker.assign_volume_level(ConfigGame.jingle_volume_level)

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
