class_name BlockingPlayerState extends PlayerActionState

@export var MOUSE_SENSITIVITY = 0.002
var move_sword = false
var target

func enter(_previous_state) -> void:
	pass

func update(delta):
	if Input.is_action_just_released("block"):
		transition.emit("LockingPlayerState", true)
	
func exit() -> void:
	pass
