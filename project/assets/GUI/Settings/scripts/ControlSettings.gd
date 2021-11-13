extends Control


func _ready() -> void:
	_translate()


func _translate() -> void:
	$Content/Head/Title.text = tr("control")
	$Content/Head/Subtitle.text = tr("main_charecter")
	$Content/ControlSettings/Container/Content/WalkingForward/Left/Label.text = tr("walking_forward")
	$Content/ControlSettings/Container/Content/WalkingBackward/Left/Label.text = tr("walking_backward")
	$Content/ControlSettings/Container/Content/Jump/Left/Label.text = tr("jump")
	$Content/ControlSettings/Container/Content/Squat/Left/Label.text = tr("squat")
	$Content/ControlSettings/Container/Content/Run/Left/Label.text = tr("run")
	$Content/ControlSettings/Container/Content/Shot/Left/Label.text = tr("shot")
	$"Content/ControlSettings/Container/Content/Close-fighting/Left/Label".text = tr("сlose_fighting")
	$Content/ControlSettings/Container/Content/Interaction/Left/Label.text = tr("interaction")
	
