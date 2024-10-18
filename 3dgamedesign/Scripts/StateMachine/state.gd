class_name State extends Node

signal transition(new_state_name: StringName, is_combat_state: bool)

func enter(previous_state) -> void:
	pass

func exit() -> void:
	pass
	
func update(delta: float) -> void:
	pass
	
func physics_update(delta: float) -> void:
	pass
