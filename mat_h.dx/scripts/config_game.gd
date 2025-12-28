extends Node

# visual dimension limits
# Maximums
# -vertDimen 9 (can push 10, but it teeters the line too close for me)
# -horiDimen 7
# Minimums (TODO, might need to program further to make values <5 visually acceptable)
# -vertDimen ?
# -horiDimen ?
var vertical_dimension = 5
var horizontal_dimension = 5
var password_length = 5 # I don't think this is used anywhere meaningfully.

func _ready() -> void:
	print("config.gd... loaded")
