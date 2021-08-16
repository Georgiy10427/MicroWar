extends KinematicBody2D

const screen_scale = 1.9
const isAutoRotateToSlide = true # Autorotate player to move direction
const DefaultSpeedValue = 200*screen_scale # Player speed value
var Speed = DefaultSpeedValue # Player speed value (for processing)
var Velocity = Vector2() # Player velocity
var second_jump = true # Flag for double jump (Is allow second jump?)
var release_space = true # Flag for double jump (The space was released?)
var is_squat = false # Is squat state? 
var timer = 0 # Seconds Timer 
var move_direct = true # True - right, False - left
var run_bot = false
var stay = false
const Floor = Vector2(0, -1) # Floor velocity
const Gravity = 2500*screen_scale # Gravity value
const JumpPowerUp = 500*screen_scale # Jump power value
const ShiftPower = 2.5 # Shift turbo value
const SitPower = -150 # Sit down power
var rng = RandomNumberGenerator.new()

func _physics_process(_delta):
	if !run_bot:
		return

	# Is stay?
	if stay:
		Velocity.y += (Gravity * _delta)
		Velocity = move_and_slide(Velocity, Floor)
		return

	# Reset flags for double jump
	if is_on_floor():
		second_jump = true
	release_space = true
	
	# Set bot move direct
	if move_direct:
		Velocity.x = Speed
		if isAutoRotateToSlide:
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.play("Walk")
	else:
		Velocity.x = -Speed
		if isAutoRotateToSlide:
			$AnimatedSprite.flip_h = true
		$AnimatedSprite.play("Walk")
	
	# Animate the charecter 
	if self.position[0] >= 0 && self.position[0] <= 125:
		if is_on_floor():
			Velocity.y = -JumpPowerUp
			$AnimatedSprite.play("jump")
			release_space = false
		elif second_jump and release_space:
			Velocity.y -= JumpPowerUp
			second_jump = false
			release_space = false
	elif self.position[0] >= 169 && self.position[0] <= 180:
		if is_on_floor():
			Velocity.y = -JumpPowerUp
			$AnimatedSprite.play("jump")
			release_space = false
	elif self.position[0] >= 180 && self.position[0] <= 198:
		Speed = DefaultSpeedValue * ShiftPower
	elif self.position[0] >= 200 and self.position[0] <= 210:
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
	
	# Calculate the physics and move the player 
	Velocity.y += (Gravity * _delta)
	Velocity = move_and_slide(Velocity, Floor)
	run_bot = false
	stay = false


func _on_Timer_timeout(): 
	move_direct = !move_direct

func _on_Delay_timeout(): # Delay the animation
	run_bot = true

func _on_StayTime_timeout():
	stay = !stay
