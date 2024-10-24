class_name BlockingPlayerState extends PlayerActionState

func enter(_previous_state) -> void:
	PLAYER.SWORD.position = Vector3(1.5, 0.75, -1)
	PLAYER.SWORD.rotation = Vector3(0, 1.87, 0.45)
	PLAYER.blocking = true

func update(delta):
	if Input.is_action_just_released("block"):
		transition.emit("LockingPlayerState", true)
	
func exit() -> void:
	PLAYER.default_sword()
	PLAYER.blocking = false
