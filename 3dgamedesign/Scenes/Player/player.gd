class_name Player extends CharacterBody3D

@export var MOUSE_SENSITIVITY: float = 0.002
@export var CAMERA_CONTROLLER: Camera3D
@export var ANIMATION_PLAYER : AnimationPlayer
@export var SWORD: Node3D

var original_sword_position
var original_sword_rotation

var mouse_captured: bool = false

var current_rotation: float
var camera_rotation: Vector2
var sword_rotation: Vector2

var target = null
var lock_camera: bool = false
var blocking: bool = false
var sword_position: Vector2

var gravity = 12.0


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
	if Input.is_action_just_pressed("exit"): get_tree().quit()
	
func _ready():
	# save the original sword position and rotation for later use
	original_sword_position = SWORD.position
	original_sword_rotation = SWORD.rotation
	# set the global variable "player"
	Global.player = self
	# capture the mouse
	capture_mouse()

func _process(delta: float) -> void:
	if lock_camera:
		camera_follow_enemy(target)
	
	# this shows the players velocity in the debug panel
	Global.debug.add_property("Velocity","%.2f" % velocity.length(), 2)

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
	
# update the sword to rotate along one plane
func update_sword_blocking(movement):
	var angle = remap(SWORD.rotation.x, -0.4, 1.2, PI, 1.5 * PI)
	var normal = Vector2.RIGHT.rotated(angle)
	
	SWORD.rotation.x += normal.cross(movement) * MOUSE_SENSITIVITY
	SWORD.rotation.x = clampf(SWORD.rotation.x, -0.4, 1.2)
	
	
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
