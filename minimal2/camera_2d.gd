extends Camera2D
@export var player: Node
@export var distance: float = 50
@export var follow_speed: float = 5.0  # Higher = faster follow

func _process(delta: float) -> void:
	if abs(global_position.distance_to(player.global_position)) > distance:
		# Smooth lerp toward player
		global_position = global_position.lerp(player.global_position, follow_speed * delta)
