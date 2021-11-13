extends Control

# Language choicebox
var languages: Array = ["russian", "english"]
var current_language:int = 0
onready var language_choicebox: Label = $Parameters/Container/Language/ChoiceBox/Value

# Quality choicebox
var quality_variants: Array = ["low", "medium", "high"]
var current_quality: int = 1
onready var quality_choicebox: Label = $Parameters/Container/Quality/ChoiceBox/Value

# Checkboxes
onready var vsync_checkbox:CheckBox = $Parameters/Container/VSync/Checkbox/Value
onready var fullscreen_checkbox: CheckBox = $Parameters/Container/Fullscreen/Checkbox/Value


func _ready() -> void:
	init_language_choicebox()
	init_quality_choicebox()
	init_vsync_checkbox()
	init_fullscreen_checkbox()
	_translate()


func init_language_choicebox() -> void:
	match TranslationServer.get_locale():
		"en":
			language_choicebox.text = tr("english")
		"ru":
			language_choicebox.text = tr("russian")


func init_quality_choicebox() -> void:
	var index: int = quality_variants.find(
		settings.settings_config.get_value("Grathics", "quality", "medium")
	)
	if index != -1:
		current_quality = index
	else:
		print_debug("Uncorrect param: quality.")


func init_vsync_checkbox() -> void:
	vsync_checkbox.pressed = settings.settings_config.get_value("Grathics", "vsync", true)


func init_fullscreen_checkbox() -> void:
	fullscreen_checkbox.pressed = settings.settings_config.get_value("Grathics", "fullscreen", true)


func _translate() -> void:
	$Head/Title.text = tr("settings_title")
	$Head/Subtitle.text = tr("general_subtitle")
	$Parameters/Container/Language/Caption.text = tr("language_param")
	$Parameters/Container/Quality/Caption.text = tr("quality")
	$Parameters/Container/VSync/Caption.text = tr("vsync")
	$Parameters/Container/Fullscreen/Caption.text = tr("fullscreen_mode")
	_update_quality_choicebox()


func _choicebox_slide_back(current_value: int, variants: Array) -> int:
	if current_value > 0:
		current_value -= 1
	else:
		current_value = len(variants) - 1
	return current_value


func _choicebox_slide_next(current_value: int, variants: Array) -> int:
	if current_value < len(variants) - 1:
		current_value += 1
	else:
		current_value = 0
	return current_value


func _apply_language(lang: String) -> void:
	match lang.substr(0, 2).to_lower():
		"en":
			TranslationServer.set_locale("en")
			settings.settings_config.set_value("Localization", "language", "en")
		"ru":
			TranslationServer.set_locale("ru")
			settings.settings_config.set_value("Localization", "language", "ru")
	_translate()
	settings.save_config()


func _previous_language_pressed() -> void:
	current_language = _choicebox_slide_back(current_language, languages)
	_apply_language(languages[current_language])
	language_choicebox.text = tr(languages[current_language])


func _next_language_pressed() -> void:
	current_language = _choicebox_slide_next(current_language, languages)
	_apply_language(languages[current_language])
	language_choicebox.text = tr(languages[current_language])


func _previous_quality_value_pressed() -> void:
	current_quality = _choicebox_slide_back(current_quality, quality_variants)
	quality_choicebox.text = tr(quality_variants[current_quality])
	settings.settings_config.set_value("Grathics", "quality", quality_variants[current_quality])
	settings.save_config()
	settings.apply_quality(settings.settings_config)


func _next_quality_value_pressed() -> void:
	current_quality = _choicebox_slide_next(current_quality, quality_variants)
	quality_choicebox.text = tr(quality_variants[current_quality])
	settings.settings_config.set_value("Grathics", "quality", quality_variants[current_quality])
	settings.save_config()
	settings.apply_quality(settings.settings_config)


func _update_quality_choicebox() -> void:
	quality_choicebox.text = tr(quality_variants[current_quality])


func _on_vsync_toggled(button_pressed: bool) -> void:
	settings.settings_config.set_value("Grathics", "vsync", button_pressed)
	settings.save_config()
	settings.apply_vsync(settings.settings_config)


func _fullscreen_toggled(button_pressed) -> void:
	settings.settings_config.set_value("Grathics", "fullscreen", button_pressed)
	settings.save_config()
	settings.configure_window(settings.settings_config)
