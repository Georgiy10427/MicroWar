extends HBoxContainer

onready var value = $Value
onready var spacer = $Space

var values = ["640 x 480", "1280 x 720", "1920 x 1080"]
var current_value:int = 2
var value_width = len(values[current_value])
onready var spacer_width = len(spacer.text)
const default_value = "640x480"

func centralize_value():
	var add_width = len(value.text) - value_width
	spacer.text = ""
	for _i in range(spacer_width + -add_width):
		spacer.text += " "

func _ready():
	value.text = settings.settings_config.get_value("Grathics", "resolution", default_value)
	value.text = value.text.replace("x", " x ")
	current_value = values.find(value.text)
	centralize_value()

func _on_LeftButton_pressed():
	if current_value > 0:
		current_value -= 1
	else:
		current_value = len(values) - 1
	
	value.text = values[current_value]
	
	centralize_value()
	
	set_resolution(value.text.replace(" x ", "x"))

func _on_RightButton_pressed():
	if current_value < len(values) - 1:
		current_value += 1
	else:
		current_value = 0
	
	value.text = values[current_value]

	centralize_value()
	set_resolution(value.text.replace(" x ", "x"))

func set_resolution(value:String):
	settings.settings_config.set_value("Grathics", "resolution", value)
	settings.save_config()
