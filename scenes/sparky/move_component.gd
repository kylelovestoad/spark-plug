extends Node

func try_movement() -> Vector2:
	
	return Vector2(
		Input.get_axis("move_left", "move_right"), # -1 for left and 1 for right
		Input.get_axis("move_up", "move_down")
	)
	
func try_hold_jump() -> bool:
	return Input.is_action_pressed("jump")

func try_jump() -> bool:
	return Input.is_action_just_pressed("jump")
