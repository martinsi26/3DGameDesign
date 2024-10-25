class_name Boar extends Enemy

func _ready() -> void:
	Global.enemy = self
	
# move the enemy to point towards the player
func enemy_charge(player) -> void:
	var pos = player.global_position
	look_at(Vector3(pos.z, 0, pos.z), Vector3(0,1,0), true)
