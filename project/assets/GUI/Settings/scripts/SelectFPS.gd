extends HBoxContainer

onready var value = $Value
export var parameters = ["30", "60", "-"]
export (int, 0, 3) var current_value:int = 0

func _ready():
	value.text = parameters[current_value]

func _on_LeftButton_pressed():
	if current_value > 0:
		current_value -= 1
	else:
		current_value = len(parameters) - 1
	
	value.text = parameters[current_value]

func _on_RightButton_pressed():
	if current_value < len(parameters) - 1:
		current_value += 1
	else:
		current_value = 0
	
	value.text = parameters[current_value]
