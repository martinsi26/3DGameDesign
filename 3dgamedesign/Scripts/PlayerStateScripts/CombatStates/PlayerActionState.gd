class_name PlayerActionState extends State


var PLAYER: Player
var ENEMY: Enemy

# Called when the node enters the scene tree for the first time.
func _ready():
	await owner.ready
	PLAYER = owner as Player
	ENEMY = PLAYER.get_parent().get_node("Enemy")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
