class_name WalkingMinotaurState extends MinotaurState

@export var SPEED: float = 3.0  # Speed of the enemy
@export var ACCELERATION: float = 0.1
@export var DECELERATION: float = 0.25
@export var TOP_ANIM_SPEED: float = 2.2

func enter(_previous_state) -> void:
	# Ensure the animation is set to loop and then play it
	MINOTAUR.animation_player.get_animation("RUNINPLACE").loop = true
	MINOTAUR.animation_player.play("RUNINPLACE")  # Start RUNINPLACE animation

func exit() -> void:
	# Optionally stop the animation if needed
	# MINOTAUR.animation_player.stop()
	pass

func update(delta: float) -> void:
	MINOTAUR.enemy_follow_player(PLAYER)
	MINOTAUR.update_gravity(delta)
	MINOTAUR.update_velocity()
	
	if !MINOTAUR.is_on_floor():
		return

	var movement_target = PLAYER.global_position
	MINOTAUR.set_movement_target(movement_target)
	MINOTAUR.apply_movement(movement_target, SPEED)
	
	if !MINOTAUR.on_cooldown and MINOTAUR.in_range:
		transition.emit("AttackMinotaurState")
	
	if MINOTAUR.on_cooldown and MINOTAUR.in_range:
		SPEED = 0  # Stop moving during cooldown
		
	if MINOTAUR.on_cooldown and !MINOTAUR.in_range:
		SPEED = 3  # Resume moving if out of range
		
	if MINOTAUR.is_dead:
		transition.emit("DeathMinotaurState")

func set_animation_speed(speed: float) -> void:
	var alpha = remap(speed, 0.0, SPEED, 0.0, 1.0)
	# Here you can control the animation speed if desired
	# ANIMATION.speed_scale = lerp(0.0, TOP_ANIM_SPEED, alpha)
