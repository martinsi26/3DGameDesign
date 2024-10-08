class_name LockingPlayerState extends PlayerActionState

@export var MOUSE_SENSITIVITY = 0.002
var target

func enter(_previous_state) -> void:
	target = PLAYER.find_target()
	PLAYER.lock_camera = true

func update(delta):
	PLAYER.camera_follow_enemy(target)

	if Input.is_action_just_pressed("lock"):
		PLAYER.lock_camera = false
		PLAYER.default_sword()
		transition.emit("IdleCombatPlayerState", true)
		
	if Input.is_action_just_pressed("slash"):
		transition.emit("AttackingPlayerState", true)
