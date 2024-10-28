class_name CooldownBoarState extends BoarState

func enter(_previous_state) -> void:
	#BOAR.animation.stop("Charge")
	$"../../ChargeCooldownTimer".start()
	$"../../ChargeHitbox".monitoring = false
	
func update(delta):
	BOAR.update_gravity(delta)

	if BOAR.is_dead:
		transition.emit("DeathBoarState")

func _on_charge_cooldown_timer_timeout() -> void:
	$"../../ChargeHitbox".monitoring = true
	transition.emit("ChargeBoarState")
