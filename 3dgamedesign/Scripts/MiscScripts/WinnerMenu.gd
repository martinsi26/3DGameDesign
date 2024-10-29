extends Control

#texture: Found on www.freepik.com

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Victory.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_again_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Sandbox.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
