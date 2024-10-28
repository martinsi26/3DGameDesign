class_name DeathMinotaurState extends MinotaurState

func enter(_previous_state):
	# Play the death animation
	MINOTAUR.animation_player.play("Defeat")  # Make sure "Defeat" is the name of your animation
	
	await MINOTAUR.animation_player.animation_finished
	
	MINOTAUR.get_node("PlayerBlockingHitbox").collision_layer = 0
	MINOTAUR.get_node("PlayerBlockingHitbox").collision_mask = 0
	MINOTAUR.collision_mask = 0
	MINOTAUR.collision_layer = 0
	MINOTAUR.remove_from_group("Enemy")
	
	if PLAYER.target == MINOTAUR:
		if !PLAYER.find_target():
			PLAYER.lock_camera = false
			PLAYER.default_sword()
	else:
		PLAYER.lock_camera = false
		PLAYER.default_sword()
		
	await get_tree().create_timer(1.5).timeout
	
	MINOTAUR.queue_free()
