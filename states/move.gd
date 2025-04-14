extends State

@export
var fall_state: State
@export
var idle_state: State
@export
var jump_state: State

func enter() -> void:
	super()
	parent.velocity.x = 0 # Just to make sure


func process_physics(delta: float) -> State:
	
	if parent.move_component.try_jump():
		return jump_state

	parent.velocity += parent.get_gravity() * delta

	var movement = get_movement_input().x * parent.move_speed
	
	if movement == 0:
		return idle_state
	
	parent.velocity.x = movement
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		# Remove a jump, since you shouldn't be able to jump an extra time
		parent.jumps -= 1 
		return fall_state
		
	return null
