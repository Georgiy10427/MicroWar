extends Control


func _ready() -> void:
	_translate()


func _translate() -> void:
	$Head/Title.text = tr("sound")
	$Head/Subtitle.text = tr("audio-setting")
	$AudioSettings/Container/Params/Volume/Left/Label.text = tr("volume")
	$AudioSettings/Container/Params/Soundtrack/Left/Label.text = tr("soundtrack")
	$AudioSettings/Container/Params/SoundtrackVolume/Left/Label.text = tr("soundtrack_volume")
	$AudioSettings/Container/Params/SoundEffects/Left/Name.text = tr("sound_effects")
	$AudioSettings/Container/Params/VolumeSoundEffects/Left/Name.text = tr("volume_sound_effects")

