extends State

@export
var idle_state: State
@export
var move_state: State
@export
var jump_state: State
@export
var grapple_state: State

# Physics processing for the state
func process_physics(delta: float) -> State:
	
	var result = parent.try_grapple()
	if result:
		parent.grapple_position = result.position
		return grapple_state
	
	if parent.coyote_time > 0.0:
		parent.coyote_time -= delta
	elif parent.coyote_jump:
		parent.jumps -= 1 # Remove a jump when falling
		parent.coyote_jump = false
		
	parent.velocity += parent.gravity() * delta

	# Horizontal air movement
	var direction = parent.move_component.try_movement().x
	var target_speed = direction * parent.move_speed
	var acceleration = parent.air_move_acceleration
	if sign(direction) != sign(parent.velocity.x) and direction != 0:
		acceleration = parent.air_turn_acceleration
	
	var movement = move_toward(
		parent.velocity.x, 
		target_speed, 
		acceleration * delta
	)
	
	parent.velocity.x = movement
	parent.move_and_slide()
	
	## Check for buffered input or double jump
	if parent.move_component.try_jump():
		if parent.jumps > 0:
			return jump_state
		else:
			parent.jump_buffer_time = parent.jump_buffer_max
			parent.jump_buffered = true

	# The player is done the jump
	if parent.is_on_floor():
		parent.jumps = parent.max_jumps
		parent.grapples = parent.max_grapples
		
		if parent.jump_buffered:
			return jump_state
			
		parent.jump_buffer_time = parent.jump_buffer_max
		if movement != 0:
			return move_state
		return idle_state
		
	# Countdown buffer time
	if parent.jump_buffered:
		parent.jump_buffer_time -= delta
		if parent.jump_buffer_time <= 0.0:
			parent.jump_buffered = false
			
	return null
