extends Area2D

func _on_Aid_body_entered(body):
	if "Player" in body.name:
		body.add_health(25)
		queue_free()

