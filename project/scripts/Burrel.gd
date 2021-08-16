extends RigidBody2D

# https://www.youtube.com/watch?v=pz-KUm_TD5o

var on_water = false
var old_water_value = false

var Velocity = Vector2()

var start_push = 4000
var local_gravity = 0

## Написать класс, отвечающий за контроль перемещений
var is_impulse = false

func _physics_process(_delta):
	water_physics(_delta)

func water_physics(_delta):
	self.rotation = 0 # Reset rotation
	if on_water:
		Velocity.y = -98 * _delta # Reset global gravity
		
		if on_water != old_water_value:
			Velocity.y += start_push # Push down burrel
			old_water_value = on_water

		Velocity.y += local_gravity # Push up burrel
		apply_impulse(Vector2(0, 0), Velocity)
		self.set_linear_velocity(Velocity) # Apply Velocity
