extends Position2D

var bottle = load("res://Bottle.tscn")

func _on_Timer_timeout():
	var s = bottle.instance()
	s.initialize(self.position)
	get_tree().current_scene.add_child(s)
