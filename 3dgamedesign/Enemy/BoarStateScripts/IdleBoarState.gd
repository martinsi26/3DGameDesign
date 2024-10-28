class_name IdleBoarState extends BoarState

func enter(_previous_state):
	await get_tree().create_timer(1).timeout
	
	transition.emit("ChargeBoarState")
	
