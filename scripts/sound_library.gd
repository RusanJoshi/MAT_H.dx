extends Node

var keypress_directional: Array[AudioStream] = [
	preload("res://assets/sfx/keypress_1.wav"),
	preload("res://assets/sfx/keypress_2.wav"),
	preload("res://assets/sfx/keypress_3.wav"),
	preload("res://assets/sfx/keypress_4.wav"),
	preload("res://assets/sfx/keypress_5.wav"),
	preload("res://assets/sfx/keypress_6.wav"),
	preload("res://assets/sfx/keypress_7.wav"),
	preload("res://assets/sfx/keypress_8.wav"),
	preload("res://assets/sfx/keypress_9.wav")
]

var keypress_confirmation: Array[AudioStream] = [
	preload("res://assets/sfx/keypress_confirmation_1.wav"),
	preload("res://assets/sfx/keypress_confirmation_2.wav"),
	preload("res://assets/sfx/keypress_confirmation_3.wav"),
	preload("res://assets/sfx/keypress_confirmation_4.wav"),
	preload("res://assets/sfx/keypress_confirmation_5.wav")
]

var particle_jingle: Array[AudioStream] = [
	preload("res://assets/sfx/particle_jingle_deep_1.wav"),
	preload("res://assets/sfx/particle_jingle_deep_2.wav"),
	preload("res://assets/sfx/particle_jingle_deep_3.wav"),
	preload("res://assets/sfx/particle_jingle_deep_4.wav"),
	preload("res://assets/sfx/particle_jingle_high_1.wav"),
	preload("res://assets/sfx/particle_jingle_high_2.wav"),
	preload("res://assets/sfx/particle_jingle_high_3.wav")
]


func _ready() -> void:
	print("sound_library.gd... loaded")
