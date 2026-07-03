extends Node2D


func _ready() -> void:
	print("unlocks_window.gd... loaded")
	
	UIManager.kill_unlocks_window.connect(kill_window)


func kill_window():
	self.queue_free()


#(?)faint pulsing background
