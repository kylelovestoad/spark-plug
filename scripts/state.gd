# Effectively an interface that states can implement
class_name State
extends Node
var parent: Node2D

# When the state is entered
func enter() -> void:
	pass

# When the state is exited
func exit() -> void:
	pass

# Input processing for the state
func process_input(event: InputEvent) -> State:
	return null

# Frame processing for the state
func process_frame(delta: float) -> State:
	return null

# Physics processing for the state
func process_physics(delta: float) -> State:
	return null
