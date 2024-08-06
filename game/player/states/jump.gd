extends PlayerState

@export var land_timer: Timer

func enter(_msg:={}) -> void:
	player.sprite.jump(
		player.jump_height, player.jump_time_to_peak, player.jump_time_to_fall
	)
	
	land_timer.start(player.jump_time_to_peak + player.jump_time_to_fall)

func physics_update(delta: float) -> void:
	var move_vector = player.get_move_vector()
	player.velocity = move_vector * player.move_speed

func _on_land_timer_timeout() -> void:
	player.land_particles.restart()
	if player.get_move_vector().length() > 0.0:
		state_machine.transition_to("Move")
	else:
		state_machine.transition_to("Idle")
