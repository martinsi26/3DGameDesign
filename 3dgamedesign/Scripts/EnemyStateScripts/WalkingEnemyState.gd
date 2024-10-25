class_name WalkingEnemyState extends EnemyState

@export var SPEED: float = 3.0  # Speed of the enemy
@export var ACCELERATION: float = 0.1
@export var DECELERATION: float = 0.25
@export var TOP_ANIM_SPEED: float = 2.2

func enter(_previous_state) -> void:
	pass

func exit() -> void:
	#ANIMATION.speed_scale = 1.0
	pass

func update(delta: float) -> void:
	ENEMY.enemy_follow_player(PLAYER)
	ENEMY.update_gravity(delta)
	ENEMY.update_velocity()
	if !ENEMY.is_on_floor():
		return

	var movement_target = PLAYER.global_position
	ENEMY.set_movement_target(movement_target)
	ENEMY.check_movement(movement_target, SPEED)
	
	if !ENEMY.on_cooldown and ENEMY.in_range:
		transition.emit("AttackEnemyState")
	
	if ENEMY.on_cooldown and ENEMY.in_range:
		SPEED = 0
	
	if ENEMY.on_cooldown and !ENEMY.in_range:
		SPEED = 3
		
	if ENEMY.is_dead:
		transition.emit("IdleEnemyState")

func set_animation_speed(speed: float) -> void:
	var alpha = remap(speed, 0.0, SPEED, 0.0, 1.0)
	#ANIMATION.speed_scale = lerp(0.0, TOP_ANIM_SPEED, alpha)
