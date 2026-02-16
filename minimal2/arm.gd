extends RigidBody2D

@export var right_arm := true
@export var pull_force := 2500.0
@export var grab_delay := 0.15
@export var freeze_time := 3.0

@onready var sprite := $Sprite2D
@onready var joint := $DampedSpringJoint2D

@export var player:Node = null

var grab_timer := 0.0
var frozen_timer := 0.0
var can_grab := false

func _ready():
	contact_monitor = true
	max_contacts_reported = 4
	linear_damp = 6.0
	angular_damp = 10.0

func _process(delta):
	if freeze:
		sprite.modulate.a = 1 - lerp(0, 1, (frozen_timer/freeze_time))
		$Label.modulate.a = 1 - lerp(0, 1, (frozen_timer/freeze_time))
	if right_arm and Input.is_action_just_pressed("right") and freeze:
		release_arm()
		return	
	if !right_arm and Input.is_action_just_pressed("left") and freeze:
		release_arm()
		return
	if freeze:
		frozen_timer += delta
		if frozen_timer >= freeze_time:
			release_arm()
		return

	var pulling := false
	if right_arm and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		pulling = true
	elif not right_arm and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		pulling = true

	if pulling:
		grab_timer += delta
		pull_if_stretched()
	else:
		grab_timer = 0.0
		can_grab = false

	if grab_timer >= grab_delay:
		can_grab = true

	if can_grab:
		check_for_grab()
	
	
func pull_if_stretched():
	var dir = Vector2.ZERO
	if right_arm:
		if player.left_grab or player.is_on_floor():
			dir = global_position.direction_to(get_global_mouse_position())
	if !right_arm:
		if player.right_grab or player.is_on_floor():
			dir = global_position.direction_to(get_global_mouse_position())

	apply_force(dir * pull_force)

func check_for_grab():
	for body in get_colliding_bodies():
		if body.is_in_group("wakk"):
			grab_wall()
			return

func grab_wall():
	%whistle.pitch_scale = randf_range(3, 5)
	%whistle.play()
	sprite.modulate = Color.RED
	freeze = true
	freeze_mode = RigidBody2D.FREEZE_MODE_STATIC
	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0
	frozen_timer = 0.0
	if right_arm:
		player.right_grab = true
		%left_arm.release_arm()
	else:
		player.left_grab = true
		%right_arm.release_arm()

func release_arm():
	$Label.modulate.a = 1
	if right_arm:
		player.right_grab = false
	else:
		player.left_grab = false
	
	sprite.modulate = Color.GREEN
	freeze = false
	freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0
	grab_timer = 0.0
	can_grab = false
