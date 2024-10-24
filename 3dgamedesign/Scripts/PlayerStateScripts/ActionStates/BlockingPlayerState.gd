class_name BlockingPlayerState extends PlayerActionState

func enter(_previous_state) -> void:
	#PLAYER.release_mouse()
	PLAYER.SWORD.position = Vector3(1.455, 0.743, -1.371)
	PLAYER.SWORD.rotation = Vector3(-0.41, 1.87, 0.44)
	PLAYER.blocking = true

func update(delta):
	if Input.is_action_just_released("block"):
		transition.emit("LockingPlayerState", true)
	
func exit() -> void:
	#PLAYER.capture_mouse()
	PLAYER.default_sword()
	PLAYER.blocking = false
