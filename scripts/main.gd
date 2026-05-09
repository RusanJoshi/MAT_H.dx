extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer
@onready var header_label: Label = %HeaderLabel
@onready var date_and_time: Label = %DateAndTime
@onready var matrix: Node2D = $Matrix
@onready var mini_menu: Node2D = $MiniMenu
@onready var focus_highlight_background: Panel = $FocusHighlightBackground

#focus (false = mat, true = mini menu)
var focus_boolean: bool = false
var dragging: bool = false
var drag_offset:= Vector2i.ZERO
var sensitivity: float = 1.2
var datetime_dict = Time.get_datetime_dict_from_system()


func _ready():
	print("main.gd... loaded")
	Events.victory_event.connect(win_state)
	Events.lose_event.connect(lose_state)
	Events.restart_game.connect(reset_focus_color)
	
	shin_update_focus()
	date_and_time.text = "boot: " + str(datetime_dict.month) + "-" + str(datetime_dict.day) + "-" + str(datetime_dict.year)
	
	var stylebox = focus_highlight_background.get_theme_stylebox("panel") as StyleBoxFlat
	print(stylebox.bg_color)


func _process(delta):
	if(Input.is_action_just_pressed("tab_key")): #switches focus between the matrix and mini-menu
		focus_boolean = !focus_boolean
		shin_update_focus()

func shin_update_focus():
	animation_player.play("FocusDimming")
	
	if(!focus_boolean):
		matrix.has_focus = true
		mini_menu.has_focus = false
		mini_menu.remove_menu_highlights()
		focus_highlight_background.position = Vector2(0,0)
	else:
		matrix.has_focus = false
		mini_menu.has_focus = true
		mini_menu.on_first_focus()
		focus_highlight_background.position.x = 0
		focus_highlight_background.position.y = mini_menu.position.y - 10

func win_state():
	print("main.gd, WIN")

func lose_state():
	print("main.gd, LOSE")

func reset_focus_color():
	print("main.gd, RESTART")
	#focus_highlight_background

func _on_matrix_area_2d_mouse_entered() -> void:
	if(focus_boolean):
		focus_boolean = false
		shin_update_focus()
func _on_mini_menu_area_2d_mouse_entered() -> void:
	if(!focus_boolean):
		focus_boolean = true
		shin_update_focus()

func _on_timer_timeout() -> void:
	animation_player.play("RollingBarAnimation")
