extends KinematicBody2D

var hit = null
	
func _ready():
	$RotationPoint/Line2D.remove_point(1)

func cast_beam():
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray($RotationPoint/Muzzle.global_position, -$RotationPoint/Muzzle.global_position + transform.x * 1000, [self])
	if result:
		if !hit:
			$RotationPoint/Line2D.add_point(transform.xform_inv(-result.position))
		else:
			$RotationPoint/Line2D.set_point_position(1, transform.xform_inv(result.position))
	return result
		
func _physics_process(delta):
	look_at(global_position)
	hit = cast_beam()
	if hit:
		hit = cast_beam()
