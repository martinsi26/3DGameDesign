class_name CooldownBoarState extends BoarState

func enter(_previous_state) -> void:
	$"../../ChargeCooldownTimer".start()
	
	if BOAR.is_dead:
		transition.emit("DeathBoarState")

func _on_charge_cooldown_timer_timeout() -> void:
	BOAR.hit_wall = false
	BOAR.hit_player = false
	BOAR.hit_enemy = false
	#BOAR.turn_to_player(PLAYER)
	transition.emit("IdleBoarState")
