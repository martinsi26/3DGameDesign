class_name AttackBoarState extends EnemyState

@onready var state = $"../../AnimationTree"["parameters/playback"]

@export var SPEED: float = 0.0  # Speed of the enemy
@export var ACCELERATION: float = 0.1
@export var DECELERATION: float = 0.25
@export var TOP_ANIM_SPEED: float = 2.2

var attack_finished = false
var player_outside_range = false

func enter(_previous_state) -> void:
	attack()

func update(delta: float) -> void:
	ENEMY.enemy_follow_player(PLAYER)
	#ENEMY.update_gravity(delta)
	#ENEMY.update_velocity()
	#var movement_target = PLAYER.global_position
	#ENEMY.set_movement_target(movement_target)
	#ENEMY.check_movement(movement_target)
	
	if attack_finished and player_outside_range:
		transition.emit("IdleBoarState")
		state.set("idle", true)
	elif attack_finished and !player_outside_range:
		attack_finished = false
		attack()
	
# this is the function to play the attack animation and figure out which attack is being used
func attack():
	var rand = randi_range(0, 2)
	
	if rand == 0:
		# left attack
		pass
	elif rand == 1:
		# top attack
		pass
	elif rand == 2:
		# right attack
		pass
		
	attack_finished = true

func _on_area_3d_body_entered(body: Node3D) -> void:
	player_outside_range = false

func _on_area_3d_body_exited(body: Node3D) -> void:
	player_outside_range = true
