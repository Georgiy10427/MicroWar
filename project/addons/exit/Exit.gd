extends Node

var overlay_visible = false
onready var parent = get_tree().get_root().find_node("Escape", true, false) 

func set_visible(state):
	if state:
		$Overlay.layer = 2
		$Overlay/Popup.popup_centered()
	else:
		$Overlay.layer = -2
		$Overlay/Popup.hide()

func _ready():
	set_visible(false)

func _on_YesButton_pressed():
	get_tree().quit(0)

func _on_YesButton_mouse_entered():
	$Overlay/Popup/YesButton/selected.visible = true
	$Overlay/Popup/NoButton/selected.visible = false

func _on_NoButton_pressed():
	set_visible(false)
	parent.set_visible(true)

func _on_NoButton_mouse_entered():
	$Overlay/Popup/YesButton/selected.visible = false
	$Overlay/Popup/NoButton/selected.visible = true

func _on_Background_pressed():
	set_visible(false)

