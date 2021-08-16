extends Node2D

var SPEED:int = 650
var Velocity:Vector2 = Vector2();

func _physics_process(delta):
	if SPEED < 0:
		$Plasma/Bullet.flip_h = true
	Velocity.x = SPEED * delta
	translate(Velocity)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Plasma_body_entered(body):
	if "dummy" in body.name:
		pass
	elif "Ground" in body.name \
	or "Barrel" in body.name \
	or "Box" in body.name \
	or "Platform" in body.name:
		if body is RigidBody2D:
			if SPEED < 0:
				body.apply_impulse(Vector2.ZERO, Vector2(-250, 0))
			else:
				body.apply_impulse(Vector2.ZERO, Vector2(250, 0))
		queue_free()

