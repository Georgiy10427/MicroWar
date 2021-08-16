extends Node2D

func _physics_process(delta):
	if $Player.Health == 0:
		$TimeMachine.can_use = false
		$Fade.change_scene(0.5)
		yield(get_tree().create_timer(0.6), "timeout")
		$TimeMachine.load_game()
		get_tree().paused = true
