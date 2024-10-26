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
	
# this is the function to play the attack animation and figure out which attack is being used
func attack():
	PLAYER.get_node("Indicator").visible = true
	
	attack_direction = randi_range(0, 2)
	var location_node = PLAYER.get_node("Indicator").get_node("Location")
	if attack_direction == 0:
		# left attack
		location_node.set_anchors_preset(Control.PRESET_CENTER_LEFT, true)
		location_node.get_node("Attack_Indicator").set_rotation_degrees(-90)
		pass
	elif attack_direction == 1:
		# top attack
		location_node.set_anchors_preset(Control.PRESET_CENTER_TOP, true)
		location_node.get_node("Attack_Indicator").set_rotation_degrees(0)
		pass
	elif attack_direction == 2:
		# right attack
		location_node.set_anchors_preset(Control.PRESET_CENTER_RIGHT, true)
		location_node.get_node("Attack_Indicator").set_rotation_degrees(90)
		pass
	
	$"../../IndicatorTimer".start()
	MINOTAUR.on_cooldown = true

func _on_indicator_timer_timeout() -> void:
	PLAYER.get_node("Indicator").visible = false
	
	var block_location: int = PLAYER.get_block_rotation()
	print(block_location, " ", attack_direction)
	
	if block_location != attack_direction:
		PLAYER.receive_damage(25)
	else:
		#play blocked sound
		pass
	
	$"../../CooldownTimer".start()
	
