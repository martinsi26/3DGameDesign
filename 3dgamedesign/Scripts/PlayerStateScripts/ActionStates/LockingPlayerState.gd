class_name LockingPlayerState extends PlayerActionState

func update(delta):
	if Input.is_action_just_pressed("lock"):
		PLAYER.lock_camera = false
		PLAYER.default_sword()
		transition.emit("IdleCombatPlayerState", true)
	
	if Input.is_action_pressed("slash") and !PLAYER.sword_swing:
		transition.emit("SlashingPlayerState", true)
		
	if Input.is_action_pressed("block"):
		transition.emit("BlockingPlayerState", true)
