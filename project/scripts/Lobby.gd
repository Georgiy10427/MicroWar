tool
extends Sprite

func _physics_process(_delta):
	if !$AnimatedSprite.is_playing():
		$AnimatedSprite.play("idle")
