extends SniperEnemyState

@export var turn_speed: float = 360.0
@export var wait_time: float = 1.0

@export var wait_timer: Timer

func enter(_msg:={}) -> void:
	wait_timer.start(wait_time)

func physics_update(delta: float) -> void:
	var dir_to_target = enemy.global_position.direction_to(enemy.player.global_position)
	var angle_to = Vector2.from_angle(enemy.global_rotation).angle_to(dir_to_target)
	if abs(angle_to) > deg_to_rad(1.0):
		enemy.global_rotation_degrees += turn_speed * sign(angle_to) * delta


func _on_wait_timer_timeout() -> void:
	if is_active:
		state_machine.transition_to("Shoot")
