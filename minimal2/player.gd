extends RigidBody2D

@export var phan_cam: Node
var left_grab = false
var right_grab = false

var cam_set = false

func _process(_delta: float) -> void:
	if left_grab or right_grab:
		gravity_scale = 1
	elif gravity_scale == 1:
		gravity_scale = 5


func is_on_floor() -> bool:
	for body in get_colliding_bodies():
		if body.is_in_group("wakk"):
			return true
	return false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if !cam_set:
			phan_cam.set_follow_offset(Vector2(0, -300))
			cam_set = true
