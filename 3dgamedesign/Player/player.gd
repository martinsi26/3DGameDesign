class_name Player extends CharacterBody3D

@export var MOUSE_SENSITIVITY: float = 0.002
@export var CAMERA_CONTROLLER: Camera3D
@export var ANIMATION_PLAYER : AnimationPlayer
@export var SWORD: Node3D

var mouse_captured: bool = false

var current_rotation: float
var camera_rotation: Vector2

var gravity = 12.0

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and mouse_captured:
		var mouse_event = event.relative * MOUSE_SENSITIVITY
		camera_look(mouse_event)

func camera_look(movement: Vector2):
	current_rotation = movement.x
	camera_rotation += movement
	camera_rotation.y = clamp(camera_rotation.y, -1.5, 1.2) # clamp 90 degres up and down
	
	transform.basis = Basis()
	CAMERA_CONTROLLER.transform.basis = Basis()
	
	rotate_object_local(Vector3(0,1,0), -camera_rotation.x)
	CAMERA_CONTROLLER.rotate_object_local(Vector3(1,0,0), -camera_rotation.y)
	
func _input(event):
	if Input.is_action_just_pressed("exit"): get_tree().quit()
	
func _ready():
	Global.player = self
	capture_mouse()

func _physics_process(delta):
	Global.debug.add_property("Velocity","%.2f" % velocity.length(), 2)
	
func capture_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true

func release_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false
	
func camera_follow_enemy() -> void:
	var space_state = get_world_3d().direct_space_state
	
	var mouse_position = get_viewport().get_mouse_position()
	
	var ray_length = 2000
	var ray_origin = $CameraController/Camera.project_ray_origin(mouse_position)
	var ray_end = ray_origin + $CameraController/Camera.project_ray_normal(mouse_position) * ray_length
	
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	var intersection = space_state.intersect_ray(query)
	
	print(intersection.position.x)
	
	rotate_object_local(Vector3(0,1,0), -intersection.position.x)
	
func check_lock():
	var possible_targets = get_tree().get_nodes_in_group("enemy")
	for target in possible_targets:
		if !CAMERA_CONTROLLER.is_position_in_frustum(target.global_position):
			possible_targets.erase(target)
		#if 
			possible_targets.erase(target)
	if !possible_targets.is_empty():
		return possible_targets[0]
	return null
	
	var space_state = get_world_3d().direct_space_state
	
	var mouse_position = get_viewport().get_mouse_position()
	
	var ray_length = 2000
	var ray_origin = $CameraController/Camera.project_ray_origin(mouse_position)
	var ray_end = ray_origin + $CameraController/Camera.project_ray_normal(mouse_position) * ray_length
	
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	var intersection = space_state.intersect_ray(query)
	
	return intersection
	
func update_sword():
	var space_state = get_world_3d().direct_space_state
	
	var mouse_position = get_viewport().get_mouse_position()
	
	var ray_length = 2000
	var ray_origin = $CameraController/Camera.project_ray_origin(mouse_position)
	var ray_end = ray_origin + $CameraController/Camera.project_ray_normal(mouse_position) * ray_length
	
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	var intersection = space_state.intersect_ray(query)
	
	if not intersection.is_empty():
		var pos = intersection.position
		SWORD.look_at(Vector3(pos.x, pos.y, pos.z), Vector3(0, 1, 0))
		
func update_gravity(delta) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	
func update_input(speed: float, acceleration: float, deceleration: float) -> void:
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = lerp(velocity.x,direction.x * speed, acceleration)
		velocity.z = lerp(velocity.z,direction.z * speed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration)
		velocity.z = move_toward(velocity.z, 0, deceleration)
	
func update_velocity() -> void:
	move_and_slide()
