class_name IdleBoarState extends BoarState

func update(delta):
	if PLAYER != null and !BOAR.is_dead:
		transition.emit("ChargeBoarState")
	
	if BOAR.is_dead:
		transition.emit("DeathBoarState")
