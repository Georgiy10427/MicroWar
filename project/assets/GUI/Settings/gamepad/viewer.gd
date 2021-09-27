extends Spatial

var pressed = false
var c = 0.005
var prev = 0.0

func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)

func _input(event: InputEvent):
	if pressed and event is InputEventMouseMotion \
	and event.relative.y <= c:
		#rotation.x += event.relative.y * 0.005
		$gamepad.rotation.y += event.relative.x * c

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_click"):
		pressed = true
	if Input.is_action_just_released("ui_click"):
		pressed = false

