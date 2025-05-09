extends State

@export
var fall_state: State
@export
var idle_state: State
@export
var jump_state: State
@export
var grapple_state: State
@export
var metalswim_state: State

@export
var animations: AnimatedSprite2D

@export
var move_anim: String = "move"

func enter() -> void:
	super()
	animations.interrupt_anim(move_anim)
	

func process_physics(delta: float) -> State:
	
	if parent.move_component.try_jump():
		return jump_state
		
	var result = parent.try_grapple()
	if result:
		parent.grapple_position = result.position
		return grapple_state

	parent.velocity += parent.gravity() * delta

	var direction = parent.move_component.try_movement().x
	parent.align_sprite(direction)
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
	
	var layer: TileMapLayer = parent.try_collide_metal()
	if layer:
		layer.set_collision_enabled(false)
		return metalswim_state
	
	# Player isn't moving so they are idle
	if parent.velocity.x == 0 and direction == 0:
		return idle_state
	
	if !parent.is_on_floor():
		parent.coyote_time = parent.max_coyote_time
		parent.coyote_jump = true
		return fall_state
		
	return null
