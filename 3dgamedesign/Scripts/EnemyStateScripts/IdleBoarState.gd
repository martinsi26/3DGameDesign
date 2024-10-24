class_name IdleBoarState extends EnemyState

@onready var state = $"../../AnimationTree"["parameters/playback"]

@export var SPEED: float = 0
@export var ACCELERATION: float = 0.1
@export var DECELERATION: float = 0.25

func update(delta):
	state.set("idle", true)
	
	#ENEMY.enemy_follow_player(PLAYER)
	#ENEMY.update_gravity(delta)
	#ENEMY.update_velocity()
	#var movement_target = PLAYER.global_position
	#ENEMY.set_movement_target(movement_target)
	#ENEMY.check_movement(movement_target)
	
	if PLAYER != null:
		await get_tree().create_timer(5).timeout
		transition.emit("ChargeBoarState")
