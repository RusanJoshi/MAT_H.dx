extends Node2D

@onready var focus_anim_play: AnimationPlayer = $FocusAnimPlay
@onready var rolling_bar_anim_play: AnimationPlayer = $RollingBarAnimPlay
@onready var timer: Timer = $Timer
@onready var header_label: Label = %HeaderLabel
@onready var date_and_time: Label = %DateAndTime
@onready var matrix: Node2D = $Matrix
@onready var mini_menu: Node2D = $MiniMenu
@onready var focus_highlight_background: Panel = $FocusHighlightBackground
@onready var end_flash_panel: Panel = $EndFlashPanel


#focus (false = mat, true = mini menu)
var focus_boolean: bool = false
var dragging: bool = false
var drag_offset:= Vector2i.ZERO
var sensitivity: float = 1.2
var datetime_dict = Time.get_datetime_dict_from_system()
var stylebox

func _ready():
	print("main.gd... loaded")
	Events.victory_event.connect(end_game_state.bind(true))
	Events.lose_event.connect(end_game_state.bind(false))
	Events.restart_game.connect(reset_focus_color)
	
	shin_update_focus()
	date_and_time.text = "boot: " + str(datetime_dict.month) + "-" + str(datetime_dict.day) + "-" + str(datetime_dict.year)
	
	stylebox = focus_highlight_background.get_theme_stylebox("panel") as StyleBoxFlat

func _process(delta):
	if(Input.is_action_just_pressed("tab_key")): #switches focus between the matrix and mini-menu
		focus_boolean = !focus_boolean
		shin_update_focus()


func shin_update_focus():
	
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
		
	focus_anim_play.play("FocusDimming")

func end_game_state(pState: bool): #win/lose
	if(pState):#win
		stylebox.bg_color = ConfigGame.win_focus_highlight_color
	else:#lose
		stylebox.bg_color = ConfigGame.lose_focus_highlight_color
	
	focus_boolean = !focus_boolean
	shin_update_focus()

func reset_focus_color():
	stylebox.bg_color = ConfigGame.default_focus_highlight_color
	#focus_boolean = !focus_boolean
	#shin_update_focus()

func _on_matrix_area_2d_mouse_entered() -> void:
	if(focus_boolean):
		focus_boolean = false
		shin_update_focus()
func _on_mini_menu_area_2d_mouse_entered() -> void:
	if(!focus_boolean):
		focus_boolean = true
		shin_update_focus()

func _on_timer_timeout() -> void:
	rolling_bar_anim_play.play("RollingBarAnimation")
