extends State

@export
var fall_state: State
@export
var idle_state: State
@export
var jump_state: State

func enter() -> void:
	super()

func process_physics(delta: float) -> State:
	
	if parent.move_component.try_jump():
		return jump_state

	parent.velocity += parent.test_me() * delta

	var direction = parent.move_component.try_movement().x
	var target_speed = direction * parent.move_speed
	
	var acceleration = parent.move_acceleration
	if sign(direction) != sign(parent.velocity.x) and direction != 0:
		acceleration = parent.turn_acceleration
	
	# So the player doesn't just turn on a dime/immediately go to max speed
	var movement = move_toward(
		parent.velocity.x, 
		target_speed, 
		acceleration * delta
	)
	
	parent.velocity.x = movement
	parent.move_and_slide()
	
	# Player isn't moving so they are idle
	if parent.velocity.x == 0 and direction == 0:
		return idle_state
	
	if !parent.is_on_floor():
		parent.coyote_time = parent.max_coyote_time
		parent.coyote_jump = true
		return fall_state
		
	return null
