extends Node2D

@onready var focus_anim_play: AnimationPlayer = $FocusAnimPlay
@onready var rolling_bar_anim_play: AnimationPlayer = $RollingBarAnimPlay
@onready var timer: Timer = $Timer
@onready var header_label: Label = %HeaderLabel
@onready var date_and_time: Label = %DateAndTime
@onready var matrix: Node2D = $Matrix
@onready var mini_menu: Node2D = $MiniMenu
@onready var focus_highlight_background: Panel = $FocusHighlightBackground

#What is this?
#@onready var end_flash_panel: Panel = $EndFlashPanel #[!] What is this for?

#UI
@onready var pop_up_shade: Panel = $PopUpShade
@onready var mouse_blocker_area_2d: Area2D = $MouseBlockerArea2D
@onready var matrix_area_2d: Area2D = $MatrixArea2D
@onready var mini_menu_area_2d: Area2D = $MiniMenuArea2D
var current_pop_up_window: Node2D
var unlocks_window: PackedScene = preload("res://ui/unlocks_window.tscn")
var difficulty_window: PackedScene = preload("res://ui/difficulty_window.tscn")

#focus (false = mat, true = mini menu)
var focus_boolean: bool = false
var pop_up_window_focus: bool = false
var dragging: bool = false
var drag_offset:= Vector2i.ZERO
var sensitivity: float = 1.2
var datetime_dict = Time.get_datetime_dict_from_system()
var stylebox

func _ready():
	print("main.gd... loaded")
	#UI
	UIManager.global_toggle_pop_up_shade.connect(toggle_pop_up_shade)
	UIManager.open_unlocks_window.connect(open_unlocks_window)
	UIManager.open_difficulty_window.connect(open_difficulty_window)
	
	#END GAME
	Events.victory_event.connect(end_game_state.bind(true))
	Events.lose_event.connect(end_game_state.bind(false))
	Events.restart_game.connect(reset_focus_color)
	
	update_focus()
	date_and_time.text = "boot: " + str(datetime_dict.month) + "-" + str(datetime_dict.day) + "-" + str(datetime_dict.year)
	
	stylebox = focus_highlight_background.get_theme_stylebox("panel") as StyleBoxFlat

func _process(delta):
	if(Input.is_action_just_pressed("tab_key")): #switches focus between the matrix and mini-menu
		if(!pop_up_window_focus):
			focus_boolean = !focus_boolean
			update_focus()

func toggle_pop_up_shade():
	pop_up_window_focus = !pop_up_window_focus
	if(matrix.has_focus or mini_menu.has_focus): # pop up window OPENS
		UIManager.lock_cell.emit()
		UIManager.lock_mini_menu.emit()
		matrix_area_2d.visible = false
		mini_menu_area_2d.visible = false
		matrix.has_focus = false
		mini_menu.has_focus = false
	else: # pop up window CLOSES
		UIManager.unlock_cell.emit()
		UIManager.unlock_mini_menu.emit()
		matrix_area_2d.visible = true
		mini_menu_area_2d.visible = true
		matrix.has_focus = false
		mini_menu.has_focus = true
	
	pop_up_shade.visible = !pop_up_shade.visible
	#mouse_blocker_area_2d.visible = !mouse_blocker_area_2d.visible

func open_unlocks_window():
	var unlocks_window_cartridge = unlocks_window.instantiate()
	add_child(unlocks_window_cartridge)

func open_difficulty_window():
	var difficulty_window_cartridge = difficulty_window.instantiate()
	current_pop_up_window = difficulty_window_cartridge
	add_child(current_pop_up_window)

func update_focus():
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
	update_focus()

func reset_focus_color():
	stylebox.bg_color = ConfigGame.default_focus_highlight_color

func _on_matrix_area_2d_mouse_entered() -> void:
	if(focus_boolean):
		focus_boolean = false
		update_focus()
func _on_mini_menu_area_2d_mouse_entered() -> void:
	if(!focus_boolean):
		focus_boolean = true
		update_focus()

func _on_mouse_blocker_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				#current_pop_up_window.kill_window()
				toggle_pop_up_shade()
				print("legacy pop up shade area2d activated")
func _on_timer_timeout() -> void:
	rolling_bar_anim_play.play("RollingBarAnimation")
