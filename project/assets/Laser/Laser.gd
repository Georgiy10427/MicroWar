extends KinematicBody2D

var hit = null

func _ready():
	$Line2D.remove_point(1)

func cast_beam():
	var space_rid = get_world_2d().space
	var space_state = Physics2DServer.space_get_direct_state(space_rid)
	var result = space_state.intersect_ray($Muzzle.global_position, $Muzzle.global_position + transform.x * 1000, [self])
	if result:
		if !hit:
			$Line2D.add_point(transform.xform_inv(result.position))
		else:
			$Line2D.set_point_position(1, transform.xform_inv(result.position))
	return result

func _physics_process(delta):
	#look_at(global_position)
	hit = cast_beam()
	if hit:
		hit = cast_beam()
	yield(get_tree().create_timer(0.5), "timeout")
