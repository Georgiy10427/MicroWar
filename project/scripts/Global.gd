extends Node

var min_window_size:Vector2 = Vector2(320, 240)
var max_window_size:Vector2 = Vector2(1920, 1080)

func _ready():
	OS.min_window_size = min_window_size
	OS.max_window_size = max_window_size

func exit():
	get_tree().quit()
