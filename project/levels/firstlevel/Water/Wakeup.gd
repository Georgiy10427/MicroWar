extends Area2D

var is_process = true 
#onready var water = get_parent().find_node("Water")

func _on_StartTrigger_body_entered(body):
	var water = get_parent().find_node("Water_Body")
	if not water is Node2D:
		print("Error find water body!")
		return -1 
	if body is KinematicBody2D and \
		body.name == "Player":
		if body.Velocity.x > 0 and is_process:
			is_process = false 
			water.sleep = false
		elif body.Velocity.x < 0 and !is_process:
			is_process = true 
			water.sleep = true
