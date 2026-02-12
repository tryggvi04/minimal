extends RigidBody2D

var left_grab = false
var right_grab = true


func _process(_delta: float) -> void:
	if left_grab or right_grab:
		gravity_scale = 1
	else:
		gravity_scale = 5
		print("doom")


func is_on_floor() -> bool:
	for body in get_colliding_bodies():
		if body.is_in_group("wakk"):
			return true
	return false
