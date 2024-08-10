extends SniperEnemyState

@export_range(0.0, 360.0) var max_turn: float = 15.0
@export var time_to_turn: float = 1.5

@export var min_leap_distance: float = 96.0
@export var max_leap_distance: float = 128.0

@export var time_to_peak: float = 0.5
@export var time_to_fall: float = 0.5

func enter(_msg:={}) -> void:
	var turn_angle = deg_to_rad(randf_range(-max_turn, max_turn))
	var dir_to_target = enemy.global_position.direction_to(enemy.player.global_position)
	var angle_to = Vector2.RIGHT.angle_to(dir_to_target)
	turn_angle += angle_to
	
	var tween := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(
		enemy, "global_rotation",
		turn_angle, time_to_turn
	)
	await tween.finished
	
	leap()

func leap() -> void:
	var total_time: float = time_to_peak + time_to_fall
	var jump_distance: float = randf_range(min_leap_distance, max_leap_distance)
	
	var jump_velocity: float = jump_distance / ( 0.5 * total_time )
	
	enemy.sprite.jump(48.0, time_to_peak, time_to_fall)
	enemy.velocity = Vector2.from_angle(enemy.global_rotation) * jump_velocity


func _on_height_sprite_ground_hit() -> void:
	if is_active:
		enemy.velocity = Vector2.ZERO
		state_machine.transition_to("Target")
