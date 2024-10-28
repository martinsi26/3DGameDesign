extends Node3D

var current_wave: int
@export var boar_scene: PackedScene
@export var minotaur_scene: PackedScene

var starting_nodes: int
var current_nodes: int
var wave_spawn_ended

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_wave = 0
	starting_nodes = get_child_count()
	current_nodes = get_child_count()
	position_to_next_wave()
	
func position_to_next_wave():
	if current_nodes == starting_nodes:
		wave_spawn_ended = false
		current_wave += 1
		await get_tree().create_timer(0.5).timeout
		print("current wave ", current_wave)
		var type: String
		var mob_spawn: int
		if current_wave == 1:
			type = "boar"
			mob_spawn = 2.0
		elif current_wave == 2:
			type = "boar"
			mob_spawn = 4.0
		elif current_wave == 3:
			type = "minotaur"
			mob_spawn = 1.0
		elif current_wave == 4:
			type = "minotaur"
			mob_spawn = 1.0
			prepare_spawn(type, mob_spawn)
			type = "boar"
			mob_spawn = 2.0
		elif current_wave == 5:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_tree().change_scene_to_file("res://Scenes/MiscScenes/WinnerScreen.tscn")
			
		prepare_spawn(type, mob_spawn)
		
func prepare_spawn(type, mob_spawn):
	var mob_wait_time: float = 2.0
	
	if type == "boar": # boar spawn
		var used_spawn = 0
		while mob_spawn > 0:
			var random_spawn = randi_range(1, 8)
			while used_spawn == random_spawn:
				random_spawn = randi_range(1, 8)
			used_spawn = random_spawn
			var boar
			if random_spawn == 1:
				boar = boar_scene.instantiate()
				boar.global_position = $BoarSpawnPoint1.global_position
			elif random_spawn == 2:
				boar = boar_scene.instantiate()
				boar.global_position = $BoarSpawnPoint2.global_position
			elif random_spawn == 3:
				boar = boar_scene.instantiate()
				boar.global_position = $BoarSpawnPoint3.global_position
			elif random_spawn == 4:
				boar = boar_scene.instantiate()
				boar.global_position = $BoarSpawnPoint4.global_position
			elif random_spawn == 5:
				boar = boar_scene.instantiate()
				boar.global_position = $BoarSpawnPoint5.global_position
			elif random_spawn == 6:
				boar = boar_scene.instantiate()
				boar.global_position = $BoarSpawnPoint6.global_position
			elif random_spawn == 7:
				boar = boar_scene.instantiate()
				boar.global_position = $BoarSpawnPoint7.global_position
			elif random_spawn == 8:
				boar = boar_scene.instantiate()
				boar.global_position = $BoarSpawnPoint8.global_position
			add_child(boar)
			mob_spawn -= 1
			await get_tree().create_timer(mob_wait_time).timeout
		wave_spawn_ended = true
			
	else: # minotaur spawn
		print("spawn minotaur")
		var minotaur = minotaur_scene.instantiate()
		minotaur.global_position = $MinotaurSpawnPoint.global_position
		add_child(minotaur)
		wave_spawn_ended = true
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	current_nodes = get_child_count()
	
	if wave_spawn_ended:
		position_to_next_wave()
