class_name DeathMinotaurState extends MinotaurState

func enter(_previous_state):
	MINOTAUR.remove_from_group("Enemy")
	if PLAYER.target == MINOTAUR:
		var new_target = PLAYER.find_target()
		if(new_target != null):
			PLAYER.target = new_target
		else:
			PLAYER.lock_camera = false
			PLAYER.default_sword()
		
	# play death animation
	# timer is to allow the death animation to finish before queue_free()
	# this is a placeholder and once animation is set queue_free() will
	# move to the "finished_animation()" function that is called once
	# the animation is finished
	await get_tree().create_timer(2).timeout
	MINOTAUR.queue_free()

func update(delta):
	pass	
