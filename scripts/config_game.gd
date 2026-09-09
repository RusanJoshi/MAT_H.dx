extends Node

# visual dimension limits
# Maximums
# -vertDimen 9 (can push 10, but it teeters the line too close for me)
# -horiDimen 7
# Minimums (TODO, might need to program further to make values <5 visually acceptable)
# -vertDimen ?
# -horiDimen ?
# easy(3,3) medium(5,5), hard(7,7), hardest(7,9)
var horizontal_dimension = 5
var vertical_dimension = 5
var password_length = 5 # I don't think this is used anywhere meaningfully.
var base_configure: int = 0

var crt_shader_bool: bool = true
var cell_highlight_color: Color = Color.DARK_SLATE_GRAY

var default_focus_highlight_color: Color = Color8(100, 65, 35, 100)
var win_focus_highlight_color: Color = Color8(34, 139, 34, 100)
var lose_focus_highlight_color: Color = Color8(178, 34, 34, 100)

# Toggle CRT shader/ adjust intensity
# Adjust game volume
# Adjust difficulty (matrix dimensions) (maybe input custom dimensions?)
# Toggle detection meter

func _ready() -> void:
	print("config.gd... loaded")
	#print("Color (float): r=", main_highlight_color.r, ", g=", main_highlight_color.g, ", b=", main_highlight_color.b, ", a=", main_highlight_color.a)
