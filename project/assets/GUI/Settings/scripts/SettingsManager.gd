extends Node

var settings_config = ConfigFile.new()
var config_path = "user://settings.cfg"

export var player_forward = "ui_right"
export var player_backward = "ui_left"
export var player_jump = "ui_up"


func _ready():
	# Check actions
	assert(InputMap.has_action(player_forward))
	assert(InputMap.has_action(player_backward))
	assert(InputMap.has_action(player_jump))
	# Open config
	var err = settings_config.load(config_path)
	if err != OK:
		assert(err)
	# Create config with defaults values, if does not exists.
	if !File.new().file_exists(config_path):
		print("Settings file does not exist. Creating default config...")
		create_default_config(settings_config)
	# Apply config settings
	get_and_apply_settings(settings_config)
	# Save config
	err = settings_config.save(config_path)
	if err != OK:
		assert(err)
	else:
		print("Seccess save settings config file.")

func get_and_apply_settings(config):
	# Apply resolution and fullscreen mode
	if config.get_value("Grathics", "fullscreen", true) != true:
		# Get render resolution
		var resolution = config.get_value("Grathics", "resolution", "640x480")
		resolution = resolution.split("x")
		resolution = Vector2(int(resolution[0]), int(resolution[1]))
		# Apply render resolution
		OS.window_fullscreen = false
		OS.set_window_size(resolution) 
		OS.set_window_resizable(false)
	else:
		OS.window_fullscreen = true
	
	# Apply grathics settings
	if config.get_value("Grathics", "quality", "average") == "low":
		# Low quality
		ProjectSettings.set_setting("rendering/quality/subsurface_scattering/quality", 0)
		ProjectSettings.set_setting("rendering/quality/depth/hdr", false)
		ProjectSettings.set_setting("rendering/quality/filters/msaa", 0)
	elif config.get_value("Grathics", "quality", "average") == "average":
		# Average quality
		ProjectSettings.set_setting("rendering/quality/subsurface_scattering/quality", 1)
		ProjectSettings.set_setting("rendering/quality/depth/hdr", true)
		ProjectSettings.set_setting("rendering/quality/filters/msaa", 2)
	else:
		# High quality
		ProjectSettings.set_setting("rendering/quality/subsurface_scattering/quality", 2)
		ProjectSettings.set_setting("rendering/quality/depth/hdr", true)
		ProjectSettings.set_setting("rendering/quality/filters/msaa", 3)
	
	if config.get_value("Grathics", "vsync", true) == true:
		ProjectSettings.set_setting("display/window/vsync/use_vsync", true)
	else:
		ProjectSettings.set_setting("display/window/vsync/use_vsync", true)
	
	# Apply control settings
	var player_forward_key = InputEventKey.new()
	var player_backward_key = InputEventKey.new()
	var player_jump_key = InputEventKey.new()
	
	player_forward_key = config.get_value("Control", "player_forward", 0)
	player_backward_key = config.get_value("Control", "player_backward", 0)
	player_jump_key = config.get_value("Control", "player_jump", 0)
	
	print(player_forward_key.scancode, player_backward_key.scancode, player_jump_key.scancode)
	
	# Erase actions
	InputMap.action_erase_events(player_forward)
	InputMap.action_erase_events(player_backward)
	InputMap.action_erase_events(player_jump)
	# Bind user actions
	InputMap.action_add_event(player_forward, player_forward_key)
	InputMap.action_add_event(player_backward, player_backward_key)
	InputMap.action_add_event(player_jump, player_jump_key)

func create_default_config(config):
	# Grathics
	config.set_value("Grathics", "resolution", "1270x720") 
	config.set_value("Grathics", "quality", "average")
	config.set_value("Grathics", "fixed_fps", 60)
	config.set_value("Grathics", "vsync", true)
	config.set_value("Grathics", "fullscreen", true)
	# Control
	config.set_value("Control", "player_forward", 
					InputMap.get_action_list(player_forward)[0])
	config.set_value("Control", "player_backward", 
					InputMap.get_action_list(player_backward)[0])
	config.set_value("Control", "player_jump", 
					InputMap.get_action_list(player_jump)[0])
