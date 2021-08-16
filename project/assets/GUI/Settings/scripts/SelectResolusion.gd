extends HBoxContainer

onready var value = $Value

var values = ["640 x 480", "1280 x 720", "1920 x 1080"]
var current_value:int = 0

func _on_LeftButton_pressed():
	if current_value > 0:
		current_value -= 1
	else:
		current_value = len(values) - 1
	
	value.text = values[current_value]

func _on_RightButton_pressed():
	if current_value < len(values) - 1:
		current_value += 1
	else:
		current_value = 0
	
	value.text = values[current_value]
