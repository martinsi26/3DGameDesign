class_name CooldownBoarState extends BoarState

func enter(_previous_state) -> void:
	if BOAR.animation_player.is_playing() and BOAR.animation_player.current_animation == "Charging":
		BOAR.animation_player.stop()
	$"../../ChargeCooldownTimer".start()
	$"../../ChargeHitbox".monitoring = false
	
func update(delta):
	BOAR.update_gravity(delta)

	if BOAR.is_dead:
		transition.emit("DeathBoarState")

func _on_charge_cooldown_timer_timeout() -> void:
	$"../../ChargeHitbox".monitoring = true
	transition.emit("ChargeBoarState")
