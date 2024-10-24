extends Control

#texture: Found on www.freepik.com

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Sandbox.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_how_to_play_pressed() -> void:
	$MarginContainer.visible = false
	$HowToPlay.visible = true


func _on_how_to_play_exit_options_menu() -> void:
	$MarginContainer.visible = true
	$HowToPlay.visible = false
