extends State

@export 
var move_state: State
@export 
var jump_state: State
@export
var fall_state: State
@export
var grapple_state: State
@export
var metalswim_state: State
@export
var animations: AnimatedSprite2D
@export
var idle_anim: String = "idle"

func enter() -> void:
	super()
	animations.speed_scale = 2
	
	animations.interrupt_anim(idle_anim)
	#parent.velocity.x = 0 # Just to make sure

func process_input(event: InputEvent) -> State:
	
	var result = parent.try_grapple()
	if result:
		parent.grapple_position = result.position
		return grapple_state
	
	if parent.move_component.try_jump():
		return jump_state
	
	if parent.move_component.try_movement().x != 0:
		return move_state
		
	if event.is_action("test_metal"):
		return metalswim_state
		
	return null

func process_physics(delta: float) -> State:
	parent.velocity += parent.gravity() * delta
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		parent.coyote_time = parent.max_coyote_time
		parent.coyote_jump = true
		return fall_state
	
	return null
