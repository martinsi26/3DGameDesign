class_name Enemy extends CharacterBody3D

@export var movement_speed: float = 2.0
@onready var navigation_agent: NavigationAgent3D = get_node("NavigationAgent3D")

var gravity: float = 12.0

func _ready() -> void:
	Global.enemy = self
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))

func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)
	
# move the enemy to point towards the player
func enemy_follow_player() -> void:
	self.look_at(Global.player.global_position, Vector3(0, 1, 0), true)
	#self.rotate_y(deg_to_rad(180))

func _physics_process(delta):
	# Do not query when the map has never synchronized and is empty.
	if NavigationServer3D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0:
		return
	if navigation_agent.is_navigation_finished():
		return
	
	enemy_follow_player()
	update_gravity(delta)
	
	if !is_on_floor():
		move_and_slide()
		return
		
	var movement_target = Global.player.global_position
	set_movement_target(movement_target)  # Set the target to the player's position

	var new_velocity: Vector3 = global_position.direction_to(movement_target) * movement_speed
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)
		

func _on_velocity_computed(safe_velocity: Vector3):
	velocity = safe_velocity
	move_and_slide()

func update_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta  # Apply gravity to the Y velocity
