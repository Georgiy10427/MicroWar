extends Node2D

# Buttons
onready var play_button:BaseButton = $Menu/HBoxContainer/TextureRect/PlayButton
onready var load_button:BaseButton = $Menu/HBoxContainer/TextureRect/LoadButton
onready var settings_button:BaseButton = $Menu/HBoxContainer/TextureRect/SettingsButton
onready var exit_button:BaseButton = $Menu/HBoxContainer/TextureRect/ExitButton
onready var menu_buttons:Array = [play_button, load_button, settings_button, exit_button]
# Container
onready var container:Container = $Menu
# Transit
onready var transit:Control = $Transit
# Time Machine
onready var time_machine:Node2D = $TimeMachine
# Saves state for current work load button
onready var saves:int = time_machine.get_number_of_saves()

func _ready():
	# Turn off time machine for user
	$TimeMachine.can_use = false
	# Init disable marker 
	if saves > 0:
		var disable_marker:Sprite = load_button.find_node("disabled")
		disable_marker.visible = false
	else:
		var disable_marker:Sprite = load_button.find_node("disabled")
		disable_marker.visible = true

func button_select_callback(self_button, self_visible = true, other_visible = false):
	for btn in menu_buttons:
		for child in btn.get_children():
			if "select" in child.name:
				if btn == self_button:
					child.visible = self_visible
				else:
					child.visible = other_visible

func _on_PlayButton_pressed():
	transit.change_scene("res://levels/World.tscn", 0.5, 0.2)

func _on_PlayButton_mouse_entered():
	button_select_callback(play_button)

func _on_LoadButton_pressed():
	time_machine.continue_game()

func _on_LoadButton_mouse_entered():
	if saves > 0:
		button_select_callback(load_button)
		
		var disable_marker:Sprite = load_button.find_node("disabled")
		disable_marker.visible = false
	else:
		var disable_marker:Sprite = load_button.find_node("disabled")
		disable_marker.visible = true

func _on_SettingsButton_pressed():
	container.visible = false

func _on_SettingsButton_mouse_entered():
	button_select_callback(settings_button)

func _on_ExitButton_pressed():
	get_tree().quit()

func _on_ExitButton_mouse_entered():
	button_select_callback(exit_button)

