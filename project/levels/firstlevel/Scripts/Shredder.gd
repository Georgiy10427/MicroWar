# This script destroys the physical body if it hurts the trigger. 
extends Area2D

func _on_Shredder_physical_body_body_entered(body):
	if body is RigidBody2D:
		body.queue_free()
