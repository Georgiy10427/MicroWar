extends HBoxContainer

onready var value = $Value
onready var spacer = $Space
onready var left_btn = $LeftButton
onready var right_btn = $RightButton

export var values = ["640 x 480", "1280 x 720", "1920 x 1080"]
export var current_value:int = 2

# Used to center the value in the box:
var value_width = len(values[current_value])
onready var spacer_width = len(spacer.text)

export var default_value = "640 x 480" # Used if we can't read value from config
export var enable: bool = true

func load_from_config():
	value.text = settings.settings_config.get_value("Grathics", "resolution", default_value)
	value.text = value.text.replace("x", " x ")
	current_value = values.find(value.text)

func centralize_value():
	var add_width = len(value.text) - value_width
	spacer.text = ""
	for _i in range(spacer_width + -add_width):
		spacer.text += " "

func _ready():
	assert(values[current_value])
	load_from_config()
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

func set_enable(state):
	if not state:
		enable = false
		value.text = str(OS.get_screen_size()[0]) + " x " + str(OS.get_screen_size()[1]) 
		left_btn.disabled = true
		right_btn.disabled = true
		centralize_value()
	else:
		enable = true
		value.text = values[current_value]
		left_btn.disabled = false
		right_btn.disabled = false
		centralize_value()
