class_name DeathBoarState extends BoarState

func enter(_previous_state):
	BOAR.animation_player.start("Death")
	await BOAR.animation_player.animation_finished
	BOAR.collision_mask = 0
	BOAR.collision_layer = 0
	BOAR.remove_from_group("Enemy")
	if PLAYER.target == BOAR:
		if !PLAYER.find_target():
			PLAYER.lock_camera = false
			PLAYER.default_sword()
	else:
		PLAYER.lock_camera = false
		PLAYER.default_sword()
		
	await get_tree().create_timer(1.5).timeout
	BOAR.queue_free()

func update(delta):
	pass	
