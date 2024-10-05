class_name IdleCombatPlayerState extends PlayerActionState

func update(delta):
	if Input.is_action_just_pressed("lock"):
		transition.emit("AttackPlayerState", true)
