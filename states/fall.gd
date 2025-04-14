extends State

@export
var idle_state: State
@export
var move_state: State
@export
var jump_state: State

# Physics processing for the state
func process_physics(delta: float) -> State:
		
	parent.velocity += parent.get_gravity() * delta

	var movement = parent.move_component.try_movement().x * parent.move_speed
	
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
