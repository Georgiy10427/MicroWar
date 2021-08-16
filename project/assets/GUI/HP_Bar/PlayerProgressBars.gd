extends Node2D

onready var player = get_tree().get_root().find_node("Player", true, false)
var was_init = false

func _ready():
	was_init = true

func _physics_process(_delta):
	if was_init:
		$CanvasLayer/HealthProgress.value = player.Health
		$CanvasLayer/PowerProgress.value = player.Power
