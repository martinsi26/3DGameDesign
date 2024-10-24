class_name SlashingPlayerState extends PlayerActionState

@export var LINE: Line2D
var timer_start = false

func enter(_previous_state) -> void:
	draw_point(PLAYER.sword_position)

func update(delta):
	if Input.is_action_just_pressed("lock"):
		PLAYER.lock_camera = false
		PLAYER.default_sword()
		transition.emit("IdleCombatPlayerState", true)
		
	if Input.is_action_just_released("slash"):
		if !timer_start:
			draw_point(PLAYER.sword_position)
			$"../../Timer".start()
			timer_start = true
			
func exit():
	LINE.clear_points()
	
func draw_point(position):
	LINE.add_point(position)

func _on_timer_timeout() -> void:
	timer_start = false
	transition.emit("LockingPlayerState", true)
