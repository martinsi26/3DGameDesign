extends Node3D

@onready var player = $Player
@onready var enemies = get_tree().get_nodes_in_group("Enemy")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	for enemy in enemies:
		enemy.set_movement_target(player.global_transform.origin)
