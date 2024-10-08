class_name AttackingPlayerState extends PlayerActionState

@export var MOUSE_SENSITIVITY = 0.002
var target

func enter(_previous_state) -> void:
	target = PLAYER.find_target()

func update(delta):
	PLAYER.camera_follow_enemy(target)
	
	if Input.is_action_just_released("slash"):
		transition.emit("LockingPlayerState", true)
