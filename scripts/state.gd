# Effectively an interface that states can implement
class_name State
extends Node
var parent: CharacterBody2D

# When the state is entered
func enter() -> void:
	return

# When the state is exited
func exit() -> void:
	return

# Input processing for the state
func process_input(event: InputEvent) -> State:
	return null

# Frame processing for the state
func process_frame(delta: float) -> State:
	return null

# Physics processing for the state
func process_physics(delta: float) -> State:
	return null
	
func get_jump() -> bool:
	return parent.move_component.try_movement().y > 0

func get_movement_input() -> Vector2:
	return parent.move_component.try_movement()
