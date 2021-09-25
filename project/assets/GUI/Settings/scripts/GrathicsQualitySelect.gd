extends HBoxContainer

onready var value = $Value
onready var spacer = $Space

var values = ["Низкое", "Среднее", "Высокое"]
var current_value:int = 0
var value_width = len(values[current_value])
onready var spacer_width = len(spacer.text)

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
