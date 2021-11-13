extends Node

var min_window_size:Vector2 = Vector2(1600, 900)
var max_window_size:Vector2 = Vector2(1920, 1080)


func _ready():
	OS.min_window_size = min_window_size
	OS.max_window_size = max_window_size


func exit():
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)


func _notification(event):
	if (event == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
		settings.save_window_position()
		settings.save_window_size()
		get_tree().quit()
