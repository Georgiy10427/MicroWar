extends Control

const DEFAULT_DURATION := 0.2
const DEFAULT_DELAY := 0.0

onready var _animator := $AnimationPlayer
onready var _curtain := $CanvasLayer/ColorRect

var is_load = false

func _ready():
	pause_mode = PAUSE_MODE_PROCESS # This script can't get paused

func set_color(color: Color):
	color.a = _curtain.color.a
	_curtain.color = color

func change_scene(duration: float = DEFAULT_DURATION, delay: float = DEFAULT_DELAY):
	if duration <= 0.0:
		push_error("TRANSIT ERROR: change_scene duration must be > 0. Defaulting to %s" % DEFAULT_DURATION)
		duration = DEFAULT_DURATION

	if delay < 0.0:
		push_error("TRANSIT ERROR: change_scene delay must be >= 0. Defaulting to %s" % DEFAULT_DELAY)
		delay = DEFAULT_DELAY

	# disable mouse interaction while fading out
	_curtain.mouse_filter = MOUSE_FILTER_STOP

	if delay > 0:
		yield(get_tree().create_timer(delay), "timeout")

	_animator.playback_speed = 1.0 / duration
	_animator.play("fade")
	yield(_animator, "animation_finished")

	# re-enable mouse interaction before fading back in
	_curtain.mouse_filter = MOUSE_FILTER_IGNORE

	_animator.play_backwards("fade")
	yield(_animator, "animation_finished")
	is_load = true

func _physics_process(delta):
	if !_animator.is_playing() and is_load:
		get_tree().paused = false
		is_load = false

