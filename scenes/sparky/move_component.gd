extends Node

func try_movement() -> Vector2:
	return Vector2(
		Input.get_axis("move_left", "move_right"), # -1 for left and 1 for right
		Input.is_action_just_pressed("jump") # y is 1 when jumping and 0 if not
	)
