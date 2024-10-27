class_name IdleCombatPlayerState extends PlayerActionState

func update(_delta):
	if Input.is_action_just_pressed("lock"):
		if PLAYER.find_target():
			PLAYER.lock_camera = true
			transition.emit("LockingPlayerState", true)
