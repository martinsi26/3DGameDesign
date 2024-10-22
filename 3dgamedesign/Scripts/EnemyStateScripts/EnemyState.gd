class_name EnemyState extends State

var ENEMY: Enemy
var PLAYER: Player
var ANIMATION: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await owner.ready
	ENEMY = owner as Enemy
	PLAYER = ENEMY.get_parent().get_node("Player")
	#ANIMATION = ENEMY.ANIMATION_PLAYER

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
