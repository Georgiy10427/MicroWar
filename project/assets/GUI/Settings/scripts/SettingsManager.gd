extends Node

var config = ConfigFile.new()
var config_path = "user://settings.cfg"

func _ready():
	var err = config.load("user://settings.cfg")
	if err != OK:
		return err

func add_section(name, value=""):
	if not config.has_section(name):
		config.set_value(name, value, false)

func erase_section(name):
	if config.has_section(name):
		config.erase_section(name)

func save():
	# Save the changes by overwriting the previous file
	var err = config.save(config_path)
	return err

#func create_default_config():
#	add_section("display_resolution", )

#func _physics_process(delta):
	#print(get_viewport().size)
