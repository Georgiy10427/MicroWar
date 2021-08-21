extends Control

onready var animation = $MainWindow/Animation
onready var window = $MainWindow/TextureRect

func open_window():
	animation.play("open")

func hide_window():
	animation.play("hidden")

func close_window():
	animation.play("close")
	yield(get_tree().create_timer(0.3), "timeout")
	return 0

func _on_CloseButton_pressed():
	close_window()
	var parent = get_parent()
	if parent != null:
		if parent.name == "Menu" and parent is Node2D \
		and parent.has_method("open_window"):
			parent.open_window()
