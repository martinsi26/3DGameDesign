#extends Node
#class_name Camera
#
#@export var look_at: Node3D
#var root_player: LocalPlayer
#
#@onready var camera = $CameraController/Camera
#@onready var focus_ponit = $FocusPoint
#@onready var camera_next = $CameraNest
#
#@onready var is_target_locked: bool = false
#@onready var target: Node3D = camera_next
#
#var offset: Vector3
#var mouse_is_captured: bool = true
#
#@onready var current_state: CameraState = $FreeCamera
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
