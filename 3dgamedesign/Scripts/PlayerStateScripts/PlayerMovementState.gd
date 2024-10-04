class_name PlayerMovementState extends State

var PLAYER: Player
var ENEMY: Enemy
var ANIMATION: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await owner.ready
	PLAYER = owner as Player
	ANIMATION = PLAYER.ANIMATION_PLAYER
	ENEMY = PLAYER.get_parent().get_node("Enemy")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
