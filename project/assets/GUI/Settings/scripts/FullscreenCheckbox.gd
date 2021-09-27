extends HBoxContainer

onready var checkbox = $Value

func _ready():
	checkbox.pressed = settings.settings_config.get_value("Grathics", "fullscreen", true)

func _on_Value_toggled(button_pressed):
	settings.settings_config.set_value("Grathics", "fullscreen", checkbox.pressed)
	settings.save_config()
