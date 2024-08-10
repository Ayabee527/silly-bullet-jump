extends SniperEnemyState

@export var turn_speed: float = 180.0
@export var recoil_distance: float = 16.0
@export var max_shots: int = 3

@export var recoil_time: float = 0.3
@export var recover_time: float = 1.0
@export var recoil_timer: Timer

var shots: int = 0

func enter(_msg:={}) -> void:
	shots = 0
	enemy.weapon_handler.firing = true

func physics_update(delta: float) -> void:
	if not recoil_timer.is_stopped():
		return
	
	var dir_to_target = enemy.global_position.direction_to(enemy.player.global_position)
	var angle_to = Vector2.from_angle(enemy.global_rotation).angle_to(dir_to_target)
	if abs(angle_to) > deg_to_rad(1.0):
		enemy.global_rotation_degrees += turn_speed * sign(angle_to) * delta

func recoil() -> void:
	var time_to_peak: float = recoil_time / 2.0
	var time_to_fall: float = recoil_time / 2.0
	var total_time: float = time_to_peak + time_to_fall
	
	var jump_velocity: float = recoil_distance / ( 0.5 * total_time )
	
	enemy.sprite.jump(4.0, time_to_peak, time_to_fall)
	enemy.velocity = Vector2.from_angle(enemy.global_rotation + PI) * jump_velocity

func _on_recoil_timer_timeout() -> void:
	if is_active:
		state_machine.transition_to("Leap")


func _on_height_sprite_ground_hit() -> void:
	if is_active:
		enemy.velocity = Vector2.ZERO


func _on_weapon_handler_fired() -> void:
	shots += 1
	recoil()
	
	if shots >= max_shots:
		enemy.weapon_handler.firing = false
		recoil_timer.start(recover_time)
