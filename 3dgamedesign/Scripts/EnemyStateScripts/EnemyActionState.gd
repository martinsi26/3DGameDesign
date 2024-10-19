class_name EnemyActionState extends State

var ENEMY: Enemy

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await owner.ready
	ENEMY = owner as Enemy

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
