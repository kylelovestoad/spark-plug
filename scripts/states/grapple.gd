extends State

@export 
var idle_state: State

@export 
var fall_state: State

@export 
var move_state: State

@export 
var jump_state: State

@export
var metalswim_state: State

var grapple_time = 0.0

@export
var grapple_sfx: AudioStreamPlayer

@export
var grapple_tolerance = 16

var prev_position: Vector2

func enter() -> void:
	grapple_sfx.play()
	parent.velocity = Vector2.ZERO
	parent.jumps = parent.max_jumps
	parent.grapples -= 1
	#prev_position = parent.position
	

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

func process_physics(delta: float) -> State:
	var to_target = parent.grapple_position - parent.position
	var distance = to_target.length()
	var travel = parent.grapple_speed * delta

	# Lots of checks to make sure the player isn't stuck
	if distance <= grapple_tolerance:
		return get_exit_state()
		
	parent.velocity = parent.grapple_dir * parent.grapple_speed
	parent.move_and_slide()
		
	# Check if movement actually happened
	if parent.position.distance_to(prev_position) < 1.0:
		# Possibly stuck against a wall
		return get_exit_state()
		
	var layer: TileMapLayer = parent.try_collide_metal()
	if layer:
		layer.set_collision_enabled(false)
		return metalswim_state

	prev_position = parent.position
	return null
