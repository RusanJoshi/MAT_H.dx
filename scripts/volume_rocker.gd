extends Node2D

@onready var rocker_visual: Label = $RockerVisual

var rocker_level: int = 0
var rocker_maximum: int = 4
var rocker_visual_front: String = "[-]["
var rocker_visual_end: String = "][+]"
var cumulative_rocker_visual: String = ""

func assign_volume_level(pAssignedLevel):
	for level in pAssignedLevel:
		increase_rocker()
	update_rocker_visual()

func update_rocker_visual():
	var final_rocker_visual: String = ""
	var empty_visual: String = ""
	
	for visual_count in rocker_maximum-rocker_level:
		if(visual_count == 0 and rocker_level == 0): empty_visual += "-"
		else: empty_visual += " -"
	
	final_rocker_visual = cumulative_rocker_visual + empty_visual
	rocker_visual.text = rocker_visual_front + final_rocker_visual + rocker_visual_end

func increase_rocker():
	if(rocker_level < rocker_maximum):
		if(rocker_level == 0): cumulative_rocker_visual += "X"
		else: cumulative_rocker_visual += "-X"
		rocker_level += 1
	update_rocker_visual()

func decrease_rocker():
	var crv_length: int = cumulative_rocker_visual.length()
	if(rocker_level > 0):
		if(rocker_level == 1): cumulative_rocker_visual = cumulative_rocker_visual.left(crv_length-1)
		else: cumulative_rocker_visual = cumulative_rocker_visual.left(crv_length-2)
		rocker_level -= 1
	update_rocker_visual()

# INCREASE
func _on_increase_a_2d_mouse_entered() -> void:
	pass
func _on_increase_a_2d_mouse_exited() -> void:
	pass
func _on_increase_a_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				increase_rocker()

# DECREASE
func _on_decrease_a_2d_mouse_entered() -> void:
	pass
func _on_decrease_a_2d_mouse_exited() -> void:
	pass
func _on_decrease_a_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				decrease_rocker()
