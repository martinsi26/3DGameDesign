class_name IdleMinotaurState extends MinotaurState

var walk = false

func update(delta):
	#MINTOTAUR.animation_player.get_animation("IDLE").loop = true
	#MINOTAUR.animation_player.play("IDLE")  # Start RUNINPLACE animation
	
	if PLAYER != null and !MINOTAUR.in_range and !MINOTAUR.is_dead:
		transition.emit("WalkingMinotaurState")
	
	if MINOTAUR.in_range and !MINOTAUR.on_cooldown and !MINOTAUR.is_dead:
		transition.emit("AttackMinotaurState")
	
	if MINOTAUR.is_dead:
		transition.emit("DeathMinotaurState")
