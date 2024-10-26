class_name PlayerStateMachine extends Node

@export var CURRENT_MOVEMENT_STATE: State
@export var CURRENT_COMBAT_STATE: State
var movement_states: Dictionary = {}
var combat_states: Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			if child.is_in_group("Movement"):
				movement_states[child.name] = child
			elif child.is_in_group("Combat"):
				combat_states[child.name] = child
			child.transition.connect(on_child_transition)
		else:
			push_warning("State machine contains incompatible child node")
			
	await owner.ready
	CURRENT_MOVEMENT_STATE.enter(null)
	CURRENT_COMBAT_STATE.enter(null)
	
func _process(delta: float) -> void:
	if CURRENT_MOVEMENT_STATE:
		CURRENT_MOVEMENT_STATE.update(delta)
	if CURRENT_COMBAT_STATE:
		CURRENT_COMBAT_STATE.update(delta)
		
	Global.debug.add_property("Current Movement State", CURRENT_MOVEMENT_STATE.name, 1)
	Global.debug.add_property("Current Combat State", CURRENT_COMBAT_STATE.name, 2)
	
func _physics_process(delta: float) -> void:
	if CURRENT_MOVEMENT_STATE:
		CURRENT_MOVEMENT_STATE.physics_update(delta)
	if CURRENT_COMBAT_STATE:
		CURRENT_COMBAT_STATE.physics_update(delta)
	
func on_child_transition(new_state_name: StringName, is_combat_state: bool = false) -> void:
	if is_combat_state:
		var new_combat_state = combat_states.get(new_state_name)
		if new_combat_state != null and new_combat_state != CURRENT_COMBAT_STATE:
			CURRENT_COMBAT_STATE.exit()
			new_combat_state.enter(CURRENT_COMBAT_STATE)
			CURRENT_COMBAT_STATE = new_combat_state
		else:
			push_warning("Combat state does not exist")
	else:
		var new_state = movement_states.get(new_state_name)
		if new_state != null:
			if new_state != CURRENT_MOVEMENT_STATE:
				CURRENT_MOVEMENT_STATE.exit()
				new_state.enter(CURRENT_MOVEMENT_STATE)
				CURRENT_MOVEMENT_STATE = new_state
		else:
			push_warning("State does not exist")
