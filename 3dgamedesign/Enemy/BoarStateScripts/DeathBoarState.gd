class_name DeathBoarState extends BoarState

func enter(_previous_state):
	if BOAR.animation_player.is_playing() and BOAR.animation_player.current_animation == "Charging":
		BOAR.animation_player.stop()
	BOAR.animation_player.play("Death")
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
