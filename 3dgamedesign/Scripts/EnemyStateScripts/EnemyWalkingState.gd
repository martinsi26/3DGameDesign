class_name EnemyWalkingState extends EnemyMovementState

@export var SPEED: float = 3.0  # Speed of the enemy
@export var ACCELERATION: float = 0.1
@export var DECELERATION: float = 0.25
@export var TOP_ANIM_SPEED: float = 2.2

@export var TARGET: Node3D  # The target the enemy will move towards (e.g., Player)

func enter(_previous_state) -> void:
	pass

func exit() -> void:
	ANIMATION.speed_scale = 1.0

func update(delta: float) -> void:
	# Update gravity for the enemy
	ENEMY.update_gravity(delta)
	
	# Move towards the target (e.g., player)
	move_towards_target(delta)
	
	# Update the velocity of the enemy
	ENEMY.update_velocity()
	
	# Set the speed of the animation based on the movement
	set_animation_speed(ENEMY.velocity.length())

	# Transition logic can be based on distance to target, etc.
	if ENEMY.velocity.length() == 0.0:
		transition.emit("IdleEnemyState")

func set_animation_speed(speed: float) -> void:
	var alpha = remap(speed, 0.0, SPEED, 0.0, 1.0)
	ANIMATION.speed_scale = lerp(0.0, TOP_ANIM_SPEED, alpha)

# Move the enemy towards the target (player or patrol point)
func move_towards_target(delta: float) -> void:
	if TARGET:
		var direction = (TARGET.global_position - ENEMY.global_position).normalized()
		ENEMY.velocity.x = lerp(ENEMY.velocity.x, direction.x * SPEED, ACCELERATION)
		ENEMY.velocity.z = lerp(ENEMY.velocity.z, direction.z * SPEED, ACCELERATION)
	else:
		# Decelerate if no target
		ENEMY.velocity.x = move_toward(ENEMY.velocity.x, 0, DECELERATION)
		ENEMY.velocity.z = move_toward(ENEMY.velocity.z, 0, DECELERATION)
