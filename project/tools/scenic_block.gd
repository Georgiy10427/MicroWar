tool
extends VisualScriptCustomNode

export var title = "Сценарный блок"
export(String, MULTILINE) var text = """Когда..."""

# The name of the custom node as it appears in the search.
func _get_caption():
	return title

func _get_category():
	return "Вход"

# The text displayed after the input port / sequence arrow.
func _get_text():
	return text
"""
func _get_input_value_port_count():
	return 1

# The types of the inputs per index starting from 0.
func _get_input_value_port_type(idx):
	return TYPE_INT

func _get_input_value_port_name(idx):
	return "Вход1"

func _get_output_value_port_count():
	return 1

# The types of outputs per index starting from 0.
func _get_output_value_port_type(idx):
	return TYPE_VECTOR2

# The text displayed before each output node per index.
func _get_output_value_port_name(idx):
	return "Выход1"
"""
func _has_input_sequence_port():
	return true

# The number of output sequence ports to use
# (has to be at least one if you have an input sequence port).
func _get_output_sequence_port_count():
	return 1

	
