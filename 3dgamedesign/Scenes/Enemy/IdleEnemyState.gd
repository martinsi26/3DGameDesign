class_name IdleEnemyState extends EnemyMovementState

@export var SPEED: float = 5.0
@export var ACCELERATION: float = 0.1
@export var DECELERATION: float = 0.25

func enter(_previous_state) -> void:
	pass

func update(delta):
	pass
	# Call update functions
	# Find if there is a player then transition to the WalkingEnemyState
