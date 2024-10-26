class_name CooldownBoarState extends BoarState

func enter(_previous_state) -> void:
	$"../../ChargeCooldownTimer".start()
	
	if BOAR.is_dead:
		transition.emit("DeathBoarState")

func _on_charge_cooldown_timer_timeout() -> void:
	#BOAR.turn_to_player(PLAYER)
	transition.emit("IdleBoarState")
