extends Area2D

var is_spawn = true

func get_world():
	return get_parent().get_parent()

func get_level():
	return get_parent()

func _on_Load_body_entered(body):
	if body.name == "Player" \
	and body is KinematicBody2D:
		if body.Velocity.x > 0 and is_spawn:
			var result = get_world().unload_prev_level(get_level())
			print("Unload result:" + str(result))
			if result == 0:
				is_spawn = false
		elif body.Velocity.x < 0 and !is_spawn:
			var result = get_world().load_prev_level(get_level())
			print("Load result:" + str(result))
			if result == 0:
				is_spawn = true


func _on_Unload_pressed():
	pass # Replace with function body.


func _on_Unload2_pressed():
	pass # Replace with function body.
