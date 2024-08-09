extends PlayerState

func enter(_msg:={}) -> void:
	player.hide()
	player.sprite.jump(256.0, 0.0, 1.0)
	await get_tree().process_frame
	player.show()
	
	await player.sprite.ground_hit
	
	player.weapon_handler.show()
	player.land_particles.restart()
	player.spawned.emit()
	player.has_spawned = true
	state_machine.transition_to("Idle")
