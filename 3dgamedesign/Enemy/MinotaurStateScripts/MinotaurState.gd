class_name MinotaurState extends State

var MINOTAUR: Minotaur
var PLAYER: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await owner.ready
	MINOTAUR = owner as Minotaur
	PLAYER = Global.player
