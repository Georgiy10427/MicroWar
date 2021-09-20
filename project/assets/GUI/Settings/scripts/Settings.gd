extends Control

onready var animation = $MainWindow/Animation
onready var window = $MainWindow/TextureRect
onready var frame_window = $MainWindow/TextureRect/Window 

onready var tabs_container: Array = \
			[
			$MainWindow/TextureRect/GrathicsSettings,
			$MainWindow/TextureRect/ControlSettings,
			$MainWindow/TextureRect/AudioSettings
			]

func _ready():
	_on_Tab1_pressed() # Activate first tab

func open_window():
	animation.play("open")

func hide_window():
	animation.play("hidden")

func close_window():
	animation.play("close")
	yield(get_tree().create_timer(0.3), "timeout")
	return 0

func open_tab(index: int, tabs_container: Array, frame_window: AnimatedSprite):
	if index <= len(tabs_container) - 1:
		for tab in tabs_container:
			if tab != tabs_container[index]:
				tab.visible = false
			else:
				tab.visible = true
		frame_window.play("tab" + str(index + 1))
	else:
		print_debug("Error! Index the out of range.")

func _on_Tab1_pressed():
	open_tab(0, tabs_container, frame_window)
	
func _on_Tab2_pressed():
	open_tab(1, tabs_container, frame_window)

func _on_Tab3_pressed():
	open_tab(2, tabs_container, frame_window)

func _on_CloseButton_pressed():
	close_window()
	var parent = get_parent()
	if parent != null:
		if parent.name == "Menu" and parent is Node2D \
		and parent.has_method("open_window"):
			parent.open_window()
		elif parent is Viewport:
			global.exit()
