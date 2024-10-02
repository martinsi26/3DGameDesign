class_name JumpingPlayerState extends PlayerMovementState

@export var SPEED: float = 6.0
@export var ACCELERATION: float = 0.1
@export var DECELERATION: float = 0.25
@export var JUMP_HEIGHT: float = 4.5
@export var DOUBLE_JUMP_VELOCITY: float = 6
@export_range(0.5, 1.0, 0.01) var INPUT_MULTIPLER: float = 0.85

var DOUBLE_JUMP: bool = false

func enter(previous_state) -> void:
	PLAYER.velocity.y += JUMP_HEIGHT
	ANIMATION.pause()
	
func exit() -> void:
	DOUBLE_JUMP = false
	
func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED, ACCELERATION, DECELERATION)
	PLAYER.update_velocity()
	
	if Input.is_action_just_pressed("jump") and !DOUBLE_JUMP:
		DOUBLE_JUMP = true
		PLAYER.velocity.y = DOUBLE_JUMP_VELOCITY
	
	if PLAYER.is_on_floor():
		transition.emit("IdlePlayerState")
