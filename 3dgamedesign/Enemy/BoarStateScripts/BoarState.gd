class_name BoarState extends State

var BOAR: Boar
var PLAYER: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await owner.ready
	BOAR = owner as Boar
	PLAYER = Global.player
