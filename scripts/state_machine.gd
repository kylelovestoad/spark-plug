extends Node

@export
var starting_state: State

var current_state: State

func init(parent: CharacterBody2D) -> void:
	for child in get_children():
		child.parent = parent

	transition_to(starting_state)

func transition_to(new_state: State) -> void:
	if current_state:
		current_state.exit()

	current_state = new_state
	current_state.enter()
	
func process_physics(delta: float) -> void:
	var new_state = current_state.process_physics(delta)
	if new_state:
		transition_to(new_state)

func process_input(event: InputEvent) -> void:
	var new_state = current_state.process_input(event)
	if new_state:
		transition_to(new_state)

func process_frame(delta: float) -> void:
	var new_state = current_state.process_frame(delta)
	if new_state:
		transition_to(new_state)
