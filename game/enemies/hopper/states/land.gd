extends HopperEnemyState

@export var rest_time: float = 1.0
@export var rest_timer: Timer

func enter(_msg:={}) -> void:
	enemy.weapon_handler.shoot()
	rest_timer.start(rest_time)

func _on_rest_timer_timeout() -> void:
	if is_active:
		state_machine.transition_to("Hop")
