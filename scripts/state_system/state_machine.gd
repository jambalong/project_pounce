class_name StateMachine
extends Node

@export var initial_state: State

var current_state: State
var states: Dictionary = {}


func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(_on_child_transitioned)
	
	if initial_state:
		initial_state.enter()
		initial_state.entered.emit()
		current_state = initial_state


func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)
		current_state.timer += delta


func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)


func _on_child_transitioned(state: State, new_state_name: String) -> void:
	if state != current_state:
		return
	
	var new_state: State = states.get(new_state_name.to_lower()) as State
	
	if new_state:
		if current_state:
			current_state.timer = 0
			current_state.exit()
			current_state.exited.emit()
		
		current_state = new_state
		current_state.timer = 0
		new_state.enter()
		new_state.entered.emit()
