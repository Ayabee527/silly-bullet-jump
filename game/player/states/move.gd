extends PlayerState

func physics_update(delta: float) -> void:
	var move_vector = player.get_move_vector()
	
	player.velocity = move_vector * player.move_speed
	
	if move_vector.length() <= 0.0:
		state_machine.transition_to("Idle")
	
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump")
