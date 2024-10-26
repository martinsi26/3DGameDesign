class_name Boar extends CharacterBody3D

@onready var navigation_agent: NavigationAgent3D = get_node("NavigationAgent3D")
@onready var hitbox: Area3D = get_node("DamageHitbox")

var PLAYER

var hit_player = false
var hit_wall = false
var hit_enemy = false

var check_collision
var manual_check

var gravity: float = 12.0

var max_health: float = 100
var current_health: float = 100
var is_dead = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.boar = self
	PLAYER = Global.player
	
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))

func set_charge_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)
	
# move the enemy to point towards the player
func point_at_player(player) -> void:
	self.look_at(Vector3(player.global_position.x, 0, player.global_position.z), Vector3(0, 1, 0), true)

func _on_velocity_computed(safe_velocity: Vector3):
	velocity = safe_velocity
	
func charge_player(movement_target, speed):
	# Do not query when the map has never synchronized and is empty.
	if NavigationServer3D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0:
		return
	if navigation_agent.is_navigation_finished():
		return
	
	var new_velocity: Vector3 = global_position.direction_to(movement_target) * speed
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)	

# call the move_and_slide function so the velocity is used and the player moves
func update_velocity() -> void:
	move_and_slide()

func update_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta  # Apply gravity to the Y velocity
		
func _process(delta: float) -> void:
	if PLAYER != null:
		if !PLAYER.sword_swing:
			check_collision = false
			manual_check = false
		elif PLAYER.sword_swing and !manual_check:
			check_collision = true
			
func receive_damage(amount):
	current_health = max(0, float(current_health - amount)) 
	print("current boar enemy:", current_health)
	
	if current_health == 0:
		is_dead = true

func _on_damage_hitbox_area_entered(area: Area3D) -> void:
	if area == PLAYER.SWORD_HITBOX and check_collision:
		print("hit boar")
		receive_damage(25)
		check_collision = false
		manual_check = true

func _on_charge_hitbox_body_entered(body: Node3D) -> void:
	print("collision")
	print("this is the body ", body)
	if body.is_in_group("Walls"):
		hit_wall = true
	elif body.is_in_group("Enemy"):
		hit_enemy = true
	elif body == PLAYER:
		hit_player = true