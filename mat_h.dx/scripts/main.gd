extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer
@onready var header_label: Label = %HeaderLabel
@onready var date_and_time: Label = %DateAndTime
@onready var matrix: Node2D = $Matrix
@onready var mini_menu: Node2D = $MiniMenu
@onready var focus_highlight_background: Panel = $FocusHighlightBackground

#focus (false = mat, true = mini menu)
var focus_boolean: bool = true 

var dragging: bool = false
var drag_offset:= Vector2i.ZERO
var sensitivity: float = 1.2
var datetime_dict = Time.get_datetime_dict_from_system()


func _ready():
	print("main.gd... loaded")
	update_focus()
	date_and_time.text = "Boot: " + str(datetime_dict.month) + ", " + str(datetime_dict.year)

func _process(delta):
	if(Input.is_action_just_pressed("tab_key")): #switches focus between the matrix and mini-menu
		update_focus()

func update_focus():
	focus_boolean = !focus_boolean
	
	if(!focus_boolean):
		matrix.has_focus = true
		mini_menu.has_focus = false
		focus_highlight_background.position = Vector2(0,0)
	else:
		matrix.has_focus = false
		mini_menu.has_focus = true
		focus_highlight_background.position = mini_menu.position

func _on_timer_timeout() -> void:
	animation_player.play("RollingBarAnimation")
