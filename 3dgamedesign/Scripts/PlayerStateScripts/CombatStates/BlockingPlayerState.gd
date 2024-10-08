class_name BlockingPlayerState extends PlayerActionState

@export var MOUSE_SENSITIVITY = 0.002

func update(_delta):
	if Input.is_action_just_released("block"):
		transition.emit("LockingPlayerState", true)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_event = event.relative * MOUSE_SENSITIVITY
		#PLAYER.update_sword_block(mouse_event)
