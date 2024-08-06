extends PlayerState

func enter(_msg:={}) -> void:
	player.hide()
	await get_tree().create_timer(3.0, false).timeout
	
	player.sprite.jump(256.0, 0.0, 1.0)
	await get_tree().process_frame
	player.show()
	
	await player.sprite.ground_hit
	
	player.land_particles.restart()
	player.spawned.emit()
	state_machine.transition_to("Idle")
