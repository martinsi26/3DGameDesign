class_name AttackMinotaurState extends MinotaurState

@export var SPEED: float = 0.0  # Speed of the enemy
@export var ACCELERATION: float = 0.1
@export var DECELERATION: float = 0.25
@export var TOP_ANIM_SPEED: float = 2.2

var attack_direction

func enter(_previous_state) -> void:
	attack()

func update(delta: float) -> void:
	MINOTAUR.enemy_follow_player(PLAYER)
	
	if MINOTAUR.in_range and !MINOTAUR.on_cooldown:
		attack()
		
	if MINOTAUR.on_cooldown and !MINOTAUR.in_range:
		transition.emit("WalkingMinotaurState")
		
	if MINOTAUR.is_dead:
		transition.emit("DeathMinotaurState")

# This function initiates the attack
func attack():
	PLAYER.get_node("Indicator").visible = true
	
	attack_direction = randi_range(0, 2)  # Randomly select an attack direction (0, 1, or 2)
	var location_node = PLAYER.get_node("Indicator").get_node("Location")

	# Set the position and rotation for the attack indicator
	if attack_direction == 0:
		# Left attack
		location_node.set_anchors_preset(Control.PRESET_CENTER_LEFT, true)
		location_node.get_node("Attack_Indicator").set_rotation_degrees(-90)

	elif attack_direction == 1:
		# Top attack
		location_node.set_anchors_preset(Control.PRESET_CENTER_TOP, true)
		location_node.get_node("Attack_Indicator").set_rotation_degrees(0)
	elif attack_direction == 2:
		# Right attack
		location_node.set_anchors_preset(Control.PRESET_CENTER_RIGHT, true)
		location_node.get_node("Attack_Indicator").set_rotation_degrees(90)

	$"../../IndicatorTimer".start()
	MINOTAUR.on_cooldown = true

func _on_indicator_timer_timeout() -> void:
	PLAYER.get_node("Indicator").visible = false
	
	var block_location: int = PLAYER.get_block_rotation()
	print(block_location, " ", attack_direction)
	
	if block_location != attack_direction:
		PLAYER.receive_damage(25)  # Player receives damage if not blocking correctly
		# Play the normal attack animation based on the attack direction
		match attack_direction:
			0:
				MINOTAUR.animation_player.play("RightSlash")  # Play normal right attack animation
			1:
				MINOTAUR.animation_player.play("DownSmash")  # Play normal top attack animation
			2:
				MINOTAUR.animation_player.play("LeftSlash")  # Play normal left attack animation
	else:
		# Play the blocked animation based on the attack direction
		match attack_direction:
			0:
				MINOTAUR.animation_player.play("RightSlashBlocked")  # Play blocked right attack animation
			1:
				MINOTAUR.animation_player.play("DownBlockedd")  # Play blocked top attack animation
			2:
				MINOTAUR.animation_player.play("LeftSlashBlocked")  # Play blocked left attack animation
	
	$"../../CooldownTimer".start()
