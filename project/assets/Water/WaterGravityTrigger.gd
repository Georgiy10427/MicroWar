extends Area2D

func _on_Trigger_body_entered(body):
	if body is RigidBody2D:
		body.set_gravity_scale(-5)
