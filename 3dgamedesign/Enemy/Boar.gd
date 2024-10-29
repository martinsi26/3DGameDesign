class_name Boar extends CharacterBody3D

@onready var navigation_agent: NavigationAgent3D = get_node("NavigationAgent3D")
@onready var hitbox: Area3D = get_node("DamageHitbox")
@onready var animation_player: AnimationPlayer = get_node("CollisionShape3D/Mesh/AnimationPlayer")

var PLAYER

var charging = false

var check_collision
var manual_check

var gravity: float = 12.0

var max_health: float = 50
var current_health: float = 50
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
			
func receive_damage(amount):
	current_health = max(0, float(current_health - amount))
	
	PLAYER.play_random_audio("SlashHits")
	
	if current_health == 0:
		is_dead = true

func _on_damage_hitbox_area_entered(area: Area3D) -> void:
	if area == PLAYER.SWORD_HITBOX and PLAYER.sword_swing:
		if PLAYER.nux_mode_enabled:
			receive_damage(1000)
		else:
			receive_damage(25)
		if animation_player.is_playing():
			if animation_player.current_animation == "Damage":
				await animation_player.animation_finished
				animation_player.play("Damage")
		else:
			animation_player.play("Damage")
			

func _on_charge_hitbox_body_entered(body: Node3D) -> void:
	if body == PLAYER and charging:
		PLAYER.receive_damage(25)
		PLAYER.play_random_audio("Grunts")
	charging = false
