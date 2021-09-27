extends HBoxContainer

onready var value = $Value
onready var spacer = $Space

var values = ["Низкое", "Среднее", "Высокое"]
var current_value:int = 0
var value_width = len(values[current_value])
onready var spacer_width = len(spacer.text)
var default_value = "average"

func user_value_to_config(value:String, values:Array):
	var err = values.find(value)
	if err != -1:
		match err:
			0:
				return "low"
			1:
				return "average"
			2:
				return "high"
	else:
		print("Error: there isn't a value in array.")
		return default_value

func save_value(value:String):
	settings.settings_config.set_value("Grathics", "quality", value)
	settings.save_config()

func _ready():
	var config_value = settings.settings_config.get_value("Grathics", "quality", default_value)
	if len(values) > 2:
		match config_value:
			"low":
				current_value = 0
			"average":
				current_value = 1
			"high":
				current_value = 2
	else:
		print_debug("Uncurrect list of values!")
	value.text = values[current_value]

func _on_LeftButton_pressed():
	if current_value > 0:
		current_value -= 1
	else:
		current_value = len(values) - 1
	
	value.text = values[current_value]
	
	var add_width = len(value.text) - value_width
	spacer.text = ""
	for _i in range(spacer_width + -add_width):
		spacer.text += " "

	save_value(
		user_value_to_config(values[current_value], values)
	)

func _on_RightButton_pressed():
	if current_value < len(values) - 1:
		current_value += 1
	else:
		current_value = 0
	
	value.text = values[current_value]
	
	var add_width = len(value.text) - value_width
	spacer.text = ""
	for _i in range(spacer_width + -add_width):
		spacer.text += " "
	
	save_value(
		user_value_to_config(values[current_value], values)
	)
	
