class_name BattlePlayerState extends PlayerMovementState

@export var SPEED: float = 5.0
@export var ACCELERATION: float = 0.1
@export var DECELERATION: float = 0.25

func enter(previous_state) -> void:
	PLAYER.release_mouse()
	ANIMATION.pause()

func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED, ACCELERATION, DECELERATION)
	PLAYER.update_velocity()
	PLAYER.update_sword()
	
	if Input.is_action_just_pressed("lock"):
		transition.emit("IdlePlayerState")

func exit() -> void:
	PLAYER.capture_mouse()

