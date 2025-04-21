# Tries to abstract the input a bit for code reuse
extends Node

func try_movement() -> Vector2:
	return Vector2(
		Input.get_axis("move_left", "move_right"), # -1 for left and 1 for right
		Input.get_axis("move_up", "move_down") # -1 for up and 1 for down
	)

func try_jump() -> bool:
	return Input.is_action_just_pressed("jump")
	
func try_hold_jump() -> bool:
	return Input.is_action_pressed("jump")
	
func try_grapple() -> bool:
	return Input.is_action_just_pressed("grapple")

func try_hold_grapple() -> bool:
	return Input.is_action_pressed("grapple")
