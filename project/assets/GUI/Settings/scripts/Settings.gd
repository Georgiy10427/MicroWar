extends Control

onready var animation = $MainWindow/Animation
onready var window = $MainWindow/TextureRect
onready var frame_window = $MainWindow/TextureRect/Window 

onready var tabs_containers: Array = \
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

func _on_Tab1_pressed():
	frame_window.play("tab1")
	tabs_containers[0].visible = true
	tabs_containers[1].visible = false
	tabs_containers[2].visible = false
	
func _on_Tab2_pressed():
	frame_window.play("tab2")
	tabs_containers[0].visible = false
	tabs_containers[1].visible = true
	tabs_containers[2].visible = false

func _on_Tab3_pressed():
	frame_window.play("tab3")
	tabs_containers[0].visible = false
	tabs_containers[1].visible = false
	tabs_containers[2].visible = true

func _on_CloseButton_pressed():
	close_window()
	var parent = get_parent()
	if parent != null:
		if parent.name == "Menu" and parent is Node2D \
		and parent.has_method("open_window"):
			parent.open_window()
		elif parent is Viewport:
			global.exit()
