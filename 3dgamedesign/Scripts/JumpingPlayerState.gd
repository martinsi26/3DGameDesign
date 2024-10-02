class_name JumpingPlayerState extends PlayerMovementState

@export var SPEED: float = 6.0
@export var ACCELERATION: float = 75
@export var JUMP_HEIGHT: float = 1.75
@export var DOUBLE_JUMP_VELOCITY: float = 1.75
@export_range(0.5, 1.0, 0.01) var INPUT_MULTIPLER: float = 0.85

var DOUBLE_JUMP: bool = false

func enter(previous_state) -> void:
	ANIMATION.pause()
	
func exit() -> void:
	DOUBLE_JUMP = false
	
func update(delta):
	PLAYER.update_jumping(delta, true, JUMP_HEIGHT)
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED * INPUT_MULTIPLER, ACCELERATION, delta)
	PLAYER.update_velocity()
	
	if Input.is_action_just_pressed("jump") and !DOUBLE_JUMP:
		DOUBLE_JUMP = true
		PLAYER.update_jumping(delta, DOUBLE_JUMP, JUMP_HEIGHT)
	
	if PLAYER.is_on_floor():
		transition.emit("IdlePlayerState")
