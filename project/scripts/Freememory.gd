extends Area2D

func get_world():
	return get_parent().get_parent()

func get_level():
	return get_parent()

func _on_Point_of_nonreturn_body_entered(body):
	if body.name == "Player":
		get_world().unload_prev_level(get_level())
		queue_free()
