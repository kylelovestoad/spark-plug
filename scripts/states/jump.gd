extends State

@export
var fall_state: State
@export
var idle_state: State
@export
var move_state: State
@export
var grapple_state: State
@export
var metalswim_state: State

@export
var jump_sfx: AudioStreamPlayer

@export
var animations: AnimatedSprite2D

@export
var jump_anim: String = "jump"

# When the state is entered
func enter() -> void:
	super()
	
	animations.speed_scale = 1
	
	jump_sfx.pitch_scale = randf_range(0.9, 1.1)
	jump_sfx.play()
	
	animations.interrupt_anim(jump_anim)
	
	parent.velocity.y = parent.jump_velocity # Add jump velocity
	parent.holding_jump = true # Pressing the jump means it just started holding
	parent.jump_time = 0.0 # jump time just started
	parent.jumps -= 1 # Remove a jump
	parent.jump_buffered = false # Consume jump buffer

# Input processing for the state
func process_input(event: InputEvent) -> State:
	return null

# Frame processing for the state
func process_frame(delta: float) -> State:
	return null

# Physics processing for the state
func process_physics(delta: float) -> State:
	var result = parent.try_grapple()
	if result:
		parent.grapple_position = result.position
		return grapple_state
	
	if not parent.holding_jump and parent.move_component.try_jump() and parent.jumps > 0:
		# Re-enter jump since sparky is double jumping
		return self
	
	parent.velocity += parent.gravity() * delta

	# Variable jump height based on how long the jump is held
	if parent.holding_jump and parent.move_component.try_hold_jump():
		parent.jump_time += delta
		if parent.jump_time < parent.max_jump_hold_time:
			parent.velocity.y += parent.hold_jump_accel * delta
		else:
			parent.holding_jump = false
	else:
		parent.holding_jump = false

	# Horizontal air movement
	var direction = parent.move_component.try_movement().x
	parent.align_sprite(direction)
	
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
	
	if parent.is_on_ceiling() and parent.velocity.y > 0:
		parent.velocity.y = 0
		parent.holding_jump = false

	# Switch to fall if going down
	if parent.velocity.y > 0:
		return fall_state

	# If landed on floor, go to idle/move
	if parent.is_on_floor():
		parent.jumps = parent.max_jumps
		if movement != 0:
			return move_state
			
		return idle_state
		
	var layer: TileMapLayer = parent.try_collide_metal()
	if layer:
		layer.set_collision_enabled(false)
		return metalswim_state
	
	return null
