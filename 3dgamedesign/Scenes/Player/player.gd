class_name Player extends CharacterBody3D

@export var PLAYER_HEALTH: float = 100
@export var MOUSE_SENSITIVITY: float = 0.002
@export var CAMERA_CONTROLLER: Camera3D
@export var ANIMATION_PLAYER : AnimationPlayer
@export var SWORD: Node3D
@export var SWORD_HITBOX: Area3D

var original_sword_position
var original_sword_rotation

var mouse_captured: bool = false

var current_rotation: float
var camera_rotation: Vector2
var sword_rotation: Vector2

var target = null
var lock_camera = false
var sword_position_3D
var blocking: bool = false
var sword_position: Vector2

const min_block_angle: float = PI + 0.5
const max_block_angle: float = 2 * PI - 0.5

var gravity = 12.0

var sword_swing = false

var max_health = 100
var current_health = 100

var regen_delay_timer = 10.0
var regen_rate = 10.0
var is_regenerating = false


# This function handles user input and input events such as mouse movement
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# after checking the mouse motion event we capture the mouse and update the camer to look
		var mouse_event = event.relative * MOUSE_SENSITIVITY
		if !blocking && lock_camera:
			update_sword(mouse_event)
		elif blocking && lock_camera:
			update_sword_blocking(event.relative)
		else:
			camera_look(mouse_event)

func camera_look(movement: Vector2):
	current_rotation = movement.x
	camera_rotation += movement
	camera_rotation.y = clamp(camera_rotation.y, -1.25, 0.3)
	
	transform.basis = Basis()
	CAMERA_CONTROLLER.transform.basis = Basis()
	# first rotate the characters body so it can simulate turning when the mouse moves left/right
	rotate_object_local(Vector3(0,1,0), -camera_rotation.x)
	
	# next rotate the camera up/down according ot the mouse movement up/donw
	CAMERA_CONTROLLER.rotate_object_local(Vector3(1,0,0), -camera_rotation.y)
	
# This function handles other mouse imputs
func _input(event):
	# we want to exit the game when player has pressed escape for debugging purposes
	if Input.is_action_just_pressed("exit"): pause_toggle()

	if Input.is_action_just_pressed("take_dmg"): receive_damage(10) #NOTE: used to test whether damage works
	
func _ready():
	$PauseMenu.hide()
	# save the original sword position and rotation for later use
	original_sword_position = SWORD.position
	original_sword_rotation = SWORD.rotation
	# set the global variable "player"
	Global.player = self
	# capture the mouse
	capture_mouse()
	
	set_process(true)

func _process(delta: float) -> void:
	if lock_camera:
		camera_follow_enemy(target)
	
	# this shows the players velocity in the debug panel
	Global.debug.add_property("Velocity","%.2f" % velocity.length(), 2)
	
	if regen_delay_timer > 0:
		regen_delay_timer -= delta
	else:
		is_regenerating = true

	if is_regenerating:
		regen_health(delta)

# captures the mouse so it's not on screen
func capture_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true

# releases the captured mouse to appear on screen
func release_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false
	
# move the camera to point towards the locked on enemy
func camera_follow_enemy(target) -> void:
	var pos = target.position
	CAMERA_CONTROLLER.look_at(Vector3(pos.x, pos.y + 1.5, pos.z), Vector3(0, 1, 0))
	look_at(target.position, Vector3(0, 1, 0))
	
	camera_rotation.x = (-rotation.y)
	
# find an available enemy within the players frustum camera view (in camera view)
func find_target():
	var possible_targets = get_tree().get_nodes_in_group("Enemy")
	for target in possible_targets:
		if !CAMERA_CONTROLLER.is_position_in_frustum(target.global_position):
			possible_targets.erase(target)
	if !possible_targets.is_empty():
		target = possible_targets[0]
		return possible_targets[0]
	return null

# reset the sword to the default positions
func default_sword():
	SWORD.position = original_sword_position
	SWORD.rotation = original_sword_rotation
	SWORD.get_node("PlaceholderMesh").position = Vector3(0.93, -0.07, -1.37)
	SWORD.get_node("PlaceholderMesh").rotation = Vector3(-0.21, 2.8, -1.57)
	sword_rotation = Vector2.ZERO

# update the sword to point at the mouse position
func update_sword(movement):
	# rotate the sword and move the sword based on mouse movement
	# similar to the camera_look function, so as I move the mouse
	# in a direction the sword rotates/shifts its position based
	# on that mouse movement
	
	sword_rotation += movement
	
	sword_rotation.y = clampf(sword_rotation.y, -0.45, 0.5)
	sword_rotation.x = clampf(sword_rotation.x, -1.60, 0.25)
	
	SWORD.transform.basis = Basis()
	
	SWORD.rotate_object_local(Vector3(0,1,0), -sword_rotation.x)
	SWORD.rotate_object_local(Vector3(1,0,0), -sword_rotation.y)
	
	sword_position = $CameraController/Camera.unproject_position($Sword/PlaceholderMesh/SwordTip.global_position)
	sword_position_3D = $Sword/PlaceholderMesh/SwordTip.global_position
	
# update the sword to rotate along one plane
func update_sword_blocking(movement):
	var normal = Vector2.RIGHT.rotated(-SWORD.rotation.x)
	
	SWORD.rotation.x += normal.cross(movement) * MOUSE_SENSITIVITY
	SWORD.rotation.x = clampf(SWORD.rotation.x, min_block_angle, max_block_angle)

# returns 0, 1 or 2 based on which third of the screen the sword is angled at
func get_block_rotation() -> int:
	var sword_angle = -SWORD.rotation.x + 3 * PI # angle is inverted
	
	var first_third  = lerp(min_block_angle, max_block_angle, 1.0/3.0)
	var second_third = lerp(min_block_angle, max_block_angle, 2.0/3.0)

	if (sword_angle >= min_block_angle and sword_angle < first_third):
		return 0
	elif (sword_angle >= first_third and sword_angle <= second_third):
		return 1
	else:
		return 2
	
# update the gravity so the player falls
func update_gravity(delta) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

# get the user input and update the velocity of the player in the direction that was pressed
func update_input(speed: float, acceleration: float, deceleration: float) -> void:
	# get the user input
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	# apply the direction by the normalized vector
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		# update the velocity based on the direction (accelerate)
		velocity.x = lerp(velocity.x,direction.x * speed, acceleration)
		velocity.z = lerp(velocity.z,direction.z * speed, acceleration)
	else:
		# updat the velocity when the direciton isn't being pressed (decelerate)
		velocity.x = move_toward(velocity.x, 0, deceleration)
		velocity.z = move_toward(velocity.z, 0, deceleration)

# call the move_and_slide function so the velocity is used and the player moves
func update_velocity() -> void:
	move_and_slide()

func _on_slashing_player_state_sword_swing(start) -> void:
	if start:
		sword_swing = true
	else:
		sword_swing = false

func update_dmg_hud():
	var health_pct = float(current_health) / float(max_health)
	var hud_alpha = 1 - health_pct
	hud_alpha = hud_alpha - 0.15
	print(hud_alpha)
	#print(current_health)
	$CameraController/Camera/ColorRect.color.a = hud_alpha
	#print($CameraController/Camera/ColorRect.color.a)

func receive_damage(amount):
	current_health = max(0, float(current_health - amount)) 
	print("current health:", current_health)
	update_dmg_hud()
	
	regen_delay_timer = 10.0
	is_regenerating = false
	
	if current_health == 0:
		game_over()

func regen_health(delta):
	if regen_delay_timer <= 0 and current_health < max_health:
		current_health = min(current_health + regen_rate * delta, max_health)
		print("regen health: ", current_health)
		update_dmg_hud()

func game_over(): 
	release_mouse()
	get_tree().change_scene_to_file("res://Scenes/MiscScenes/GameOver.tscn")
	

func pause_toggle():
	if get_tree().paused:
		get_tree().paused = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		$PauseMenu.hide()
	else:
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		print("Game Paused:", get_tree().paused)
		$PauseMenu.show()
