extends Node

var settings_config = ConfigFile.new()
var config_path = "user://settings.cfg"

export var player_forward = "ui_right"
export var player_backward = "ui_left"
export var player_jump = "ui_up"
export var player_squat = "ui_squat"
export var player_acceleration = "ui_acceleration"
export var save_action = "ui_save"
export var load_action = "ui_load"
var actions = [player_forward, player_backward, player_jump,
			   player_squat, player_acceleration, save_action,
			   load_action]


func _ready():
	# Check actions
	for action in actions:
		assert(InputMap.has_action(action))
	
	# Open config
	var err = settings_config.load(config_path)
	if err != OK:
		assert(err)
	
	# Create config with defaults values, if does not exists.
	if !File.new().file_exists(config_path):
		print("Settings file does not exist. Creating default config...")
		create_default_config(settings_config)
	
	# Apply config settings
	apply_settings(settings_config)
	save_config()


func apply_resolution(config):
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


func apply_quality(config):
	# Apply grathics settings
	ProjectSettings.set_setting("rendering/quality/filters/msaa", 0)
	ProjectSettings.set_setting("rendering/quality/subsurface_scattering/quality", 0)
	match config.get_value("Grathics", "quality", "medium"):
		"low":
			# Low quality
			ProjectSettings.set_setting("rendering/quality/depth/hdr", false)
		"medium":
			# Average quality
			ProjectSettings.set_setting("rendering/quality/depth/hdr", true)
		_:
			# High quality
			ProjectSettings.set_setting("rendering/quality/depth/hdr", true)


func apply_vsync(config):
	if config.get_value("Grathics", "vsync", true) == true:
		ProjectSettings.set_setting("display/window/vsync/use_vsync", true)
	else:
		ProjectSettings.set_setting("display/window/vsync/use_vsync", true)


func apply_control(config):
	for action in actions:
		var action_key = InputEventKey.new()
		action_key = config.get_value("Control", action, 0)
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, action_key)


func apply_locale(config):
	TranslationServer.set_locale(
		config.get_value("Localization", "language", detect_locale())
	)


func apply_audio(config):
	var master_volume:float = config.get_value("Audio", "master", 0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), master_volume)


func apply_settings(config):
	apply_resolution(config)
	apply_quality(config)
	apply_vsync(config)
	apply_control(config)
	apply_audio(config)
	apply_locale(config)


func detect_locale():
	if "ru_" in OS.get_locale():
		return "ru"
	else:
		return "en"


func create_default_config(config):
	# Grathics
	config.set_value("Grathics", "resolution", "1270x720")
	config.set_value("Grathics", "quality", "medium")
	config.set_value("Grathics", "fixed_fps", 60)
	config.set_value("Grathics", "vsync", true)
	config.set_value("Grathics", "fullscreen", true)
	config.set_value("Localization", "language", detect_locale())
	# Control
	for action in actions:
		config.set_value("Control", action, InputMap.get_action_list(action)[0])
	# Audio
	config.set_value("Audio", "master", 1.0)


func save_config():
	var err = settings_config.save(config_path)
	if err != OK:
		assert(err)
	return err
