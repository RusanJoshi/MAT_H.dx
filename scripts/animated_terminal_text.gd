extends Node2D

var text_body_array: Array[String] = [
	"$ sudo apt update", #0
	"[sudo] password for user: ", "********", #1
	"Reading package lists... Done",#2
	"Building dependency tree" + #3
	"Reading state information... Done" + #3
	"All packages are up to date." #4
]

func _ready() -> void:
	pass
