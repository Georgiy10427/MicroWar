extends Area2D

onready var time_machine = get_tree().get_root().find_node("TimeMachine", true, false) # to save the player's position 

func _on_DeathTrigger_body_entered(body):
	if body.name == "Player":
		body.die()
		if time_machine.reload() == -1:
			get_tree().reload_current_scene()
