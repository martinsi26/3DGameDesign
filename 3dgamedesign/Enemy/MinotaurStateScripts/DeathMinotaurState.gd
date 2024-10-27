class_name DeathMinotaurState extends MinotaurState

func enter(_previous_state):
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
		
	# play death animation
	# timer is to allow the death animation to finish before queue_free()
	# this is a placeholder and once animation is set queue_free() will
	# move to the "finished_animation()" function that is called once
	# the animation is finished
	await get_tree().create_timer(2).timeout
	MINOTAUR.queue_free()

func update(delta):
	pass	
