class_name Player extends CharacterBody3D

@export var MOUSE_SENSITIVITY: float = 1.5
@export var CAMERA_CONTROLLER: Camera3D
@export var ANIMATION_PLAYER : AnimationPlayer

var mouse_captured: bool = false

var move_dir: Vector2 # Input direction for movement
var look_dir: Vector2

var move_vel: Vector3 # Walking velocity
var jump_vel: Vector3
var grav_vel: Vector3

var current_rotation: float

var gravity = 12.0

func capture_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true

func release_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false

func _rotate_camera(sens_mod: float = 1.0) -> void:
	current_rotation = look_dir.x
	CAMERA_CONTROLLER.rotation.y -= look_dir.x * MOUSE_SENSITIVITY * sens_mod
	CAMERA_CONTROLLER.rotation.x = clamp(CAMERA_CONTROLLER.rotation.x - look_dir.y * MOUSE_SENSITIVITY * sens_mod, -1.5, 1.5)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		look_dir = event.relative * 0.001
		if mouse_captured: _rotate_camera()
	
func _input(event):
	if Input.is_action_just_pressed("exit"): get_tree().quit()
	
func _ready():
	Global.player = self
	capture_mouse()

func _physics_process(delta):
	Global.debug.add_property("Velocity","%.2f" % velocity.length(), 2)
	
func update_jumping(delta, jumping, jump_height) -> void:
	if is_on_floor(): 
		jump_vel = Vector3(0, sqrt(4 * jump_height * gravity), 0)
	else:
		jump_vel = jump_vel.move_toward(Vector3.ZERO, gravity * delta)
		
func update_gravity(delta) -> void:
	grav_vel = Vector3.ZERO if is_on_floor() else grav_vel.move_toward(Vector3(0, velocity.y - gravity, 0), gravity * delta)
	
func update_input(speed: float, acceleration: float, delta: float) -> void:
	move_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var _forward: Vector3 = CAMERA_CONTROLLER.global_transform.basis * Vector3(move_dir.x, 0, move_dir.y)
	var walk_dir: Vector3 = Vector3(_forward.x, 0, _forward.z).normalized()
	move_vel = move_vel.move_toward(walk_dir * speed * move_dir.length(), acceleration * delta)
	
func update_velocity() -> void:
	velocity = grav_vel + move_vel + jump_vel
	move_and_slide()

