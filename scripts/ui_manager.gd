extends Node


func _ready() -> void:
	print("ui_manager.gd... loaded")


#emit: mini_menu.gd, difficulty_moption_target()
#connected: main.gd
signal global_toggle_pop_up_shade

#emit: main.gd, toggle_pop_up_window()
#connected: matrix_cell.gd
signal lock_cell
signal unlock_cell
#connected: mini_menu.gd
signal lock_mini_menu
signal unlock_mini_menu

#UNLOCKS WINDOW
signal open_unlocks_window
signal kill_unlocks_window
signal show_unlocks_window
signal hide_unlocks_window

#VOLUME WINDOW
signal open_volume_window
signal kill_volume_window
signal show_volume_window
signal hide_volume_window
signal volume_window_self_destruct

#DIFFICULTY WINDOW
signal open_difficulty_window
signal kill_difficulty_window
signal show_difficulty_window
signal hide_difficulty_window
signal difficulty_window_self_destruct

#CRT TOGGLE
#emit: minimenu.gd -> crt_effect_moption_target()
#connected: main.gd
signal toggle_crt_effect
