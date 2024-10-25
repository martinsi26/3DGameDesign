class_name BlockingPlayerState extends PlayerActionState

func enter(_previous_state) -> void:
	PLAYER.SWORD.position = Vector3(0.07, 0.37, -1.55)
	PLAYER.SWORD.rotation = Vector3(4.75, -1.6, -1.6)
	PLAYER.SWORD.get_node("PlaceholderMesh").position = Vector3(0.75, 0, 1.4)
	PLAYER.SWORD.get_node("PlaceholderMesh").rotation = Vector3(0.024, 0.183, -0.173)
	PLAYER.blocking = true

func update(delta):
	if Input.is_action_just_released("block"):
		transition.emit("LockingPlayerState", true)
	
func exit() -> void:
	PLAYER.default_sword()
	PLAYER.blocking = false
