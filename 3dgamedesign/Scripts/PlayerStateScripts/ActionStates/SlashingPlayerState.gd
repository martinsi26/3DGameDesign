class_name SlashingPlayerState extends PlayerActionState

@export var LINE: Line2D
var timer_start = false

var start_position: Vector3
var end_position: Vector3

var scale_factor = 0.01  # 1 meter = 100 pixels

signal sword_swing(start)

func enter(_previous_state) -> void:
	start_position = PLAYER.sword_position_3D
	draw_point(PLAYER.sword_position)
	LINE.modulate.a = 1  # Set to fully opaque only if it's already at 0

func update(delta):
	if Input.is_action_just_pressed("lock"):
		PLAYER.lock_camera = false
		PLAYER.default_sword()
		transition.emit("IdleCombatPlayerState", true)
	
	if Input.is_action_just_released("slash"):
		if !timer_start and !PLAYER.sword_swing:
			$"../../SwordHitbox".monitoring = true
			end_position = PLAYER.sword_position_3D
			draw_point(PLAYER.sword_position)
			emit_signal("sword_swing", true)
			$"../../OpacityTimer".start()
			timer_start = true
			
			var center = (start_position + end_position) / 2
			var length = start_position.distance_to(end_position)
			var direction = (end_position - start_position).normalized()
			
			var basis = Basis()
			basis.y = direction
			
			var right = direction.cross(direction).normalized()  # Right vector
			if right.length_squared() < 0.01:  # If right is very small (direction is vertical)
				right = Vector3(1, 0, 0)  # Use a default direction (X-axis)
				
			basis.x = right
			basis.z = basis.y.cross(basis.x).normalized()
			
			var collision_shape = $"../../SwordHitbox/CollisionShape3D"
			collision_shape.global_transform.origin = center
			collision_shape.shape.height = length
			
			collision_shape.global_transform.basis = basis
			transition.emit("LockingPlayerState", true)

func exit():
	pass
	
func draw_point(position):
	LINE.add_point(position)

func _on_opacity_timer_timeout() -> void:
	# Decrease the opacity
	LINE.modulate.a -= 0.1
	if LINE.modulate.a <= 0:
		LINE.modulate.a = 0  # Clamp to prevent negative alpha
		$"../../OpacityTimer".stop()  # Stop the timer if opacity is zero
		timer_start = false
		emit_signal("sword_swing", false)
		LINE.clear_points()
		$"../../SwordHitbox".monitoring = false
		$"../../OpacityTimer".stop()
