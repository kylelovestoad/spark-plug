extends State

@export 
var move_state: State
@export 
var jump_state: State
@export
var fall_state: State

func enter() -> void:
	super()
	parent.velocity.x = 0

func process_input(event: InputEvent) -> State:
	
	if parent.move_component.try_jump():
		return jump_state
	
	if parent.move_component.try_movement().x != 0:
		return move_state
		
	return null

func process_physics(delta: float) -> State:
	parent.velocity += parent.get_gravity() * delta
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		# Remove a jump, since you shouldn't be able to jump an extra time
		parent.jumps -= 1 
		return fall_state
	
	return null
