extends Area2D

func _on_DeathTrigger_body_entered(body):
	if body.name == "Player" and body is KinematicBody2D:
		body.die()
