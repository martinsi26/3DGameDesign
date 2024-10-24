extends ColorRect

#texture: Found on www.freepik.com

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_continue_pressed() -> void:
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	hide()


func _on_how_to_play_pressed() -> void:
	$MarginContainer.visible = false
	$HowToPlay.visible = true

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_how_to_play_exit_options_menu() -> void:
	$MarginContainer.visible = true
	$HowToPlay.visible = false
