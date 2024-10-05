class_name AttackPlayerState extends PlayerActionState

func enter(previous_state) -> void:
	PLAYER.release_mouse()

func update(delta):
	var target = PLAYER.find_target()
	if target == null:
		transition.emit("IdleCombatPlayerState", true)
	else:
		PLAYER.camera_follow_enemy(target)
		PLAYER.update_sword()
	
		if Input.is_action_just_pressed("lock"):
			transition.emit("IdleCombatPlayerState", true)
	
func exit() -> void:
	PLAYER.default_sword()
	PLAYER.capture_mouse()

