##### Spring Modeling
extends Node2D

# The spring's current velocity 
var velocity = 0
# The force beging applied to the spring
var force = 5
# The current heigth of the spring
var height = 0
# The natural position of the spring
var target_height = 0

var objects_in_water = []

onready var collision = $Area2D/Collision

# The index of this spring
# We will set it on initialize
var index = 0

# how much an external object movement will after this spring
var motion_factor = 0.005

var collided_with = null

# We will triggered
signal splash

func water_update(spring_constant, dampening):
	## This function applies the hooke's law force to the spring!!
	## This function will be called in each frame
	
	# Update the height value based on our current position
	height = position.y
	
	# The spring current extension
	var x = height - target_height
	
	var loss = -dampening * velocity
	
	# Hooke's law
	force = - spring_constant * x + loss
	
	# Apply the force to the velocity
	# Equivalent to velocity = velocity + force
	velocity += force
	
	# Make the spring move!
	position.y += velocity
	pass

func initialize(x_position, id):
	height = position.y
	target_height = position.y
	velocity = 0 
	position.x = x_position
	index = id

func set_collision_width(value):
	# This function will set the collision shape of our springs
	
	var extents = collision.shape.get_extents()
	var new_extents = Vector2(value/2, extents.y)
	collision.shape.set_extents(new_extents)


func _on_Area2D_body_entered(body):
	# Called when a body collides with a spring
	if body == collided_with:
		return
	collided_with = body
	
	# We multiply the motion of the body by the mot ion factor
	# If we didn't the speed would be huge, depending on your game
	if body.name == "Player":
		var speed = body.Velocity.y * motion_factor
		emit_signal("splash", index, speed)
		if body.god:
			return
		body.rotation_degrees = 90
		body.global_position.x += 10
		body.die()
	elif body is RigidBody2D and "Barrel" in body.name or "Box" in body.name:
		var speed = (body.position.y + body.weight) * motion_factor
		emit_signal("splash", index, speed)

func _on_Area2D_body_exited(body):
	if body == collided_with:
		collided_with = null
	
	if body is RigidBody2D and "Barrel" in body.name or "Box" in body.name:
		var speed = (body.position.y + body.weight) * motion_factor
		emit_signal("splash", index, speed)

