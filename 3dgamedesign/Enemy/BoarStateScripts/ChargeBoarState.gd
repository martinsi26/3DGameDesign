class_name ChargeBoarState extends BoarState

@export var SPEED: float = 10.0  # Speed of the enemy
@export var ACCELERATION: float = 0.1
@export var DECELERATION: float = 0.25
@export var TOP_ANIM_SPEED: float = 2.2

func enter(_previous_state) -> void:
	if BOAR.is_dead:
		transition.emit("DeathBoarState")
		return
	BOAR.charging = true
	BOAR.animation_player.get_animation("Chargeing").loop = true
	BOAR.animation_player.play("Chargeing")
	BOAR.point_at_player(PLAYER)
	var movement_target = PLAYER.global_position
	BOAR.set_charge_target(movement_target)
	BOAR.charge_player(movement_target, SPEED)

func update(delta: float) -> void:
	BOAR.update_gravity(delta)
	BOAR.update_velocity()

	if !BOAR.charging:
		transition.emit("CooldownBoarState")
		
	if BOAR.is_dead:
		transition.emit("DeathBoarState")
