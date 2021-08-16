extends Node2D

var exit_release = true
var overlay_visible = false
 
func set_visible(state):
	if state:
		$Overlay.layer = 1
		$Overlay/Popup.popup_centered()
		overlay_visible = true
	else:
		$Overlay.layer = -1
		$Overlay/Popup.hide()
		overlay_visible = false

func _ready():
	pause_mode = PAUSE_MODE_PROCESS
	set_visible(false)

func _physics_process(_delta):
	if Input.is_action_pressed("ui_exit") and exit_release:
		get_tree().paused = !get_tree().paused 
		set_visible(!overlay_visible)

		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		exit_release = false

	if !Input.is_action_pressed("ui_exit"):
		exit_release = true

func _on_ContinueButton_pressed():
	set_visible(false)
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_MenuButton_pressed():
	$Transit.change_scene("res://levels/Menu.tscn", 0.5, 0.2)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = false

func _on_ExitButton_pressed():
	$Overlay/Popup/ExitDialog.set_visible(true)
	set_visible(false)
