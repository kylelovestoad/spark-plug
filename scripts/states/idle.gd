extends State

@export 
var move_state: State
@export 
var jump_state: State
@export
var fall_state: State

func enter() -> void:
	super()
	#parent.velocity.x = 0 # Just to make sure

func process_input(event: InputEvent) -> State:
	
	if parent.move_component.try_jump():
		return jump_state
	
	if parent.move_component.try_movement().x != 0:
		return move_state
		
	return null

func process_physics(delta: float) -> State:
	parent.velocity += parent.test_me() * delta
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		parent.coyote_time = parent.max_coyote_time
		parent.coyote_jump = true
		return fall_state
	
	return null
