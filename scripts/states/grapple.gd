extends State

@export 
var idle_state: State

@export 
var fall_state: State

@export 
var move_state: State

@export 
var jump_state: State

var grapple_time = 0.0

func enter() -> void:
	parent.velocity = Vector2.ZERO
	parent.jumps = parent.max_jumps # reset jumps
	parent.grapples -= 1

func draw() -> void:
	parent.draw_line(parent.to_local(parent.position), parent.to_local(parent.grapple_position), Color.LIGHT_BLUE, 3)

func get_exit_state():
	if parent.is_on_floor():
		parent.grapples = parent.max_grapples
		if parent.velocity.x != 0:
			return move_state
		else:
			return idle_state
	else:
		return fall_state

func process_input(event):
	#if not parent.move_component.try_hold_grapple():
		#return get_exit_state()
		
	if parent.move_component.try_jump():
		return jump_state

func process_physics(delta):
	
	if grapple_time < parent.max_grapple_time:
		grapple_time += delta
		parent.velocity = (parent.grapple_position - parent.position) / parent.max_grapple_time	
	else: 
		grapple_time = 0
		return get_exit_state()
		
	parent.move_and_slide()
