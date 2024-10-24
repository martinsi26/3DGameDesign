class_name Boar extends Enemy

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

# move the enemy to point towards the player
func enemy_follow_player(player) -> void:
	self.look_at(Vector3(player.global_position.x, 0, player.global_position.z), Vector3(0, 1, 0), true)
	self.rotate_y(30)
	self.orthonormalize()
	self.axis_lock_angular_y = true

func _process(delta: float) -> void:
	move_and_slide()
