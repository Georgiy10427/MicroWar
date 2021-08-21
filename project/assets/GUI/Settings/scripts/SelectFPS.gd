extends HBoxContainer

onready var value = $Value
onready var spacer = $Space

export var parameters = ["30", "60", "Отсутствует"]
export (int, 0, 3) var current_value:int = 0
var value_width = len(parameters[current_value])
onready var spacer_width = len(spacer.text)

func _ready():
	value.text = parameters[current_value]

func _on_LeftButton_pressed():
	if current_value > 0:
		current_value -= 1
	else:
		current_value = len(parameters) - 1
	
	value.text = parameters[current_value]
	
	var add_width = len(value.text) - value_width
	spacer.text = ""
	for _i in range(spacer_width + -add_width):
		spacer.text += " "

func _on_RightButton_pressed():
	if current_value < len(parameters) - 1:
		current_value += 1
	else:
		current_value = 0
	
	value.text = parameters[current_value]
	
	var add_width = len(value.text) - value_width
	spacer.text = ""
	for _i in range(spacer_width + -add_width):
		spacer.text += " "
