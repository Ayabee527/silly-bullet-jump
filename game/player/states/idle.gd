extends PlayerState

func enter(_msg:={}) -> void:
	player.velocity = Vector2.ZERO

func physics_update(delta: float) -> void:
	var move_vector = player.get_move_vector()
	if move_vector.length() > 0.0:
		state_machine.transition_to("Move")
	
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump")
