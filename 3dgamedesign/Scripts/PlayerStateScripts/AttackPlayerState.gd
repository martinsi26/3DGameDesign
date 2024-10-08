class_name AttackPlayerState extends PlayerActionState

@export var MOUSE_SENSITIVITY = 0.002
var move_sword = false
var target

func enter(_previous_state) -> void:
	target = PLAYER.find_target()

func update(delta):
	if target == null:
		transition.emit("IdleCombatPlayerState", true)
	else:
		move_sword = true
		PLAYER.lock_camera = true
		PLAYER.camera_follow_enemy(target)
	
		if Input.is_action_just_pressed("lock"):
			transition.emit("IdleCombatPlayerState", true)
	
func exit() -> void:
	PLAYER.default_sword()
	#PLAYER.capture_mouse()
	move_sword = false
	PLAYER.lock_camera = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and move_sword:
		var mouse_event = event.relative * MOUSE_SENSITIVITY
		PLAYER.update_sword(mouse_event)
