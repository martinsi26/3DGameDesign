class_name IdleBoarState extends BoarState

func update(delta):
	await get_tree().create_timer(1).timeout
	
	if PLAYER != null and !BOAR.is_dead:
		transition.emit("ChargeBoarState")
	
	if BOAR.is_dead:
		transition.emit("DeathBoarState")
