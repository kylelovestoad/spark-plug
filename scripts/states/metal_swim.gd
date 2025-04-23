extends State

@export
var animations: AnimatedSprite2D

@export
var swim_anim: String = "swim"

func enter() -> void:
	animations.interrupt_anim(swim_anim)
	
func exit() -> void:
	animations.rotation = 0

func process_physics(delta: float) -> State:
	
	var input_direction = parent.move_component.try_movement()
	
	if input_direction != Vector2.ZERO:
		var angle = parent.swim_dir.angle_to(input_direction)
		var max_turn_angle = parent.swim_turn_rate * delta
		var clamped_angle = clamp(angle, -max_turn_angle, max_turn_angle)

		# Rotate the swim direction gradually toward input
		parent.swim_dir = parent.swim_dir.rotated(clamped_angle).normalized()
		animations.rotation = parent.swim_dir.angle()
		
	
	var target_velocity = parent.swim_dir * parent.move_speed
	
	var acceleration = Vector2(parent.move_acceleration, parent.move_acceleration)
		
	var movement = parent.velocity.move_toward( 
		target_velocity, 
		acceleration.x * delta
	)
	
	parent.velocity = movement
	if parent.is_on_wall():
		parent.velocity.x *= -1
		parent.swim_dir.x *= -1
		animations.rotation = parent.swim_dir.angle()
	if parent.is_on_floor() or parent.is_on_ceiling():
		parent.velocity.y *= -1
		parent.swim_dir.y *= -1
		animations.rotation = parent.swim_dir.angle()
	
	parent.move_and_slide()
	
	
	return null
