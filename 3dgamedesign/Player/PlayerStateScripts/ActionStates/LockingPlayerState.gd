class_name LockingPlayerState extends PlayerActionState

func update(delta):
	if Input.is_action_just_pressed("unlock"):
		PLAYER.viewed_targets = []
		PLAYER.lock_camera = false
		PLAYER.default_sword()
		transition.emit("IdleCombatPlayerState", true)
		
	if Input.is_action_just_pressed("lock"):
		PLAYER.find_target()
	
	if Input.is_action_pressed("slash") and !PLAYER.sword_swing:
		transition.emit("SlashingPlayerState", true)
		
	if Input.is_action_pressed("block"):
		transition.emit("BlockingPlayerState", true)
		
	if !PLAYER.lock_camera:
		transition.emit("IdleCombatPlayerState", true)
