class_name IdleCombatPlayerState extends PlayerActionState

func update(_delta):
	if Input.is_action_just_pressed("lock") and PLAYER.find_target():
		transition.emit("LockingPlayerState", true)
