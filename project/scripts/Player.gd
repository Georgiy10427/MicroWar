extends KinematicBody2D

export var DefaultSpeedValue:int = 420 # Player speed value
export var AutoRotate:bool = true # Autorotate player to move direction
var Speed:int = DefaultSpeedValue # Player speed value (for processing)
var Velocity:Vector2 = Vector2() # Player velocity
export var Health:int = 60 # Player's health
export var Power:int = 100  # Player's power
var second_jump:bool = true # Flag for double jump (Is allow second jump?)
var release_up:bool = true # Flag for double jump (The space was released?)
var is_squat:bool = false # Is squat state? 
var allow_power:bool = true
var shot_button_release:bool = true # Flag for shot key
const Floor:Vector2 = Vector2(0, -1) # Floor 
export var Gravity:int = 2500 # Gravity value
export var JumpPowerUp:int = 800 # Jump power value
export var ShiftPower:float = 1.25 # Shift turbo value
export var SitPower:int = -150 # Sit down power
export (float, 0, 250) var inertia = 125 

# Cheats
var god:bool = false

# Load Plasma
const Plasma:Resource = preload("res://assets/Bullet/Bullet.tscn")

func _ready():
	if OS.get_name() != "Android":
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$RunTimer.start()

func step():
	if Input.is_action_pressed("ui_left"):
		Velocity.x = -Speed
		if AutoRotate:
			$AnimatedSprite.flip_h = true
		$AnimatedSprite.play("Walk")
	elif Input.is_action_pressed("ui_right"):
		Velocity.x = Speed
		if AutoRotate:
			$AnimatedSprite.flip_h = false
		$AnimatedSprite.play("Walk")
	else:
		Velocity.x = 0
		Speed = DefaultSpeedValue
		$AnimatedSprite.stop()
		$AnimatedSprite.play("posible")

func jump():
	# Jump buttons processing
	if Input.is_action_pressed("ui_up"):
		if is_on_floor():
			Velocity.y = -JumpPowerUp
			$AnimatedSprite.play("jump")
			release_up = false
		elif second_jump and release_up:
			Input.start_joy_vibration(0, 0.45, 0.3, 0.23)
			Velocity.y -= JumpPowerUp
			second_jump = false
			release_up = false

func run_and_squat():
	# Run
	if Input.is_action_pressed("ui_acceleration") and \
		!is_squat and Power > 0 and allow_power:
		Speed = int(DefaultSpeedValue * ShiftPower)
	# Squat
	elif Input.is_action_pressed("ui_squat"):
		Speed = DefaultSpeedValue + SitPower
		$AnimatedSprite.play("SquatAction")
		$Collision.set_disabled(true)
		$CollisionSit.set_disabled(false)
		is_squat = true
	else:
		Speed = DefaultSpeedValue
		$Collision.set_disabled(false)
		$CollisionSit.set_disabled(true)
		is_squat = false
	if Power == 0:
		$RecoveryPower.start()
		allow_power = false

func reset_flags():
	# Reset flags 
	if is_on_floor():
		second_jump = true
	if !Input.is_action_pressed("ui_up"):
		release_up = true
	if !Input.is_action_pressed("ui_shot"):
		shot_button_release = true

func shot_check():
	# Shot key proccesing
	if Input.is_action_pressed("ui_shot") and shot_button_release  \
	and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		var plasma = Plasma.instance()
		if "Level_One" in get_parent().filename or "Lobby" in get_parent().filename:
			plasma.position.x = $GunPosition.global_position.x*1.9
			plasma.position.y = $GunPosition.global_position.y*1.9
		else:
			plasma.position.x = $GunPosition.global_position.x
			plasma.position.y = $GunPosition.global_position.y
		if $AnimatedSprite.flip_h: # Left player direction
			plasma.SPEED = -plasma.SPEED
		get_parent().add_child(plasma)
		shot_button_release = false
		Input.start_joy_vibration(0, 0.5, 0.5, 0.15)

func physics():
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("bodies"):
			Input.start_joy_vibration(0, 0.3, 0.45, 0.2)
			collision.collider.apply_central_impulse(-collision.normal * inertia)
		#else:
		#	Input.stop_joy_vibration(0)

func die():
	if god:
		return
	Input.start_joy_vibration(0, 0.9, 0.9, 0.9)
	Velocity = Vector2.ZERO
	$AnimatedSprite.play("posible")
	Health = 0
	Power = 0
	$RecoveryPower.stop()
	allow_power = true
	time_machine.reload()

func add_health(quantity):
	if Health < 100:
		Health += quantity

func _physics_process(_delta):
	if Health <= 0:
		Velocity.y += (Gravity * _delta)
		Velocity = move_and_slide(Velocity, Floor, 
								false, 4, 0.785398, false)
		return
	step()
	jump()
	run_and_squat()
	shot_check()
	reset_flags()
	# Calculate the physics and move the player 
	Velocity.y += (Gravity * _delta)
	Velocity = move_and_slide(Velocity, Floor,
								false, 4, 0.785398, false)
	physics()

func _on_RunTimer_timeout():
	if Speed == int(DefaultSpeedValue * ShiftPower):
		Power -= 25
	elif Power < 100:
		Power += 20

func _on_RecoveryPower_timeout():
	allow_power = true
	$RecoveryPower.stop()

