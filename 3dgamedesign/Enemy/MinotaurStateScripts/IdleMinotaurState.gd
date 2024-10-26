class_name IdleMinotaurState extends MinotaurState

var walk = false

func update(delta):
	if PLAYER != null and !MINOTAUR.in_range and !MINOTAUR.is_dead:
		transition.emit("WalkingMinotaurState")
	
	if MINOTAUR.in_range and !MINOTAUR.on_cooldown and !MINOTAUR.is_dead:
		transition.emit("AttackMinotaurState")
	
	if MINOTAUR.is_dead:
		transition.emit("DeathMinotaurState")
