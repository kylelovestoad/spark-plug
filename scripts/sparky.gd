extends CharacterBody2D

@onready
var state_machine = $StateMachine

@onready
var move_component = $MoveComponent

const SPEED = 200.0
const JUMP_VELOCITY = -120.0
const HOLD_JUMP_ACCEL = -1000.0
const MAX_JUMP_HOLD_TIME: float = 0.2
const JUMP_BUFFER_MAX = 0.2

var jump_buffer_time = 0.0
var jump_buffered = false

var jump_time = 0.0
var holding_jump = false

var max_jumps = 2
var jumps = max_jumps

func _ready() -> void:
	state_machine.init(self)
	
func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)

	## Check for buffered input
	 #if parent.move_component.try_movement().y > 0:
		#parent.jump_buffer_time = parent.JUMP_BUFFER_MAX
		#parent.jump_buffered = true
#
	## Countdown buffer time
	#if jump_buffered:
		#jump_buffer_time -= delta
		#if jump_buffer_time <= 0.0:
			#jump_buffered = false
			#
	#
	#if is_on_floor():
		#jumps = max_jumps
#
	## Jump if on floor and buffer is active
	#if jumps > 0 and jump_buffered:
		#velocity.y = JUMP_VELOCITY
		#holding_jump = true
		#jump_time = 0.0
		#jumps -= 1
		#jump_buffered = false  
#
	## Handle variable jump height
	#if holding_jump and Input.is_action_pressed("jump"):
		#jump_time += delta
		#if jump_time < MAX_JUMP_HOLD_TIME:
			#velocity.y += HOLD_JUMP_ACCEL * delta
		#else:
			#holding_jump = false
	#else:
		#holding_jump = false
#
	## Gravity 
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	#var direction := Input.get_axis("move_left", "move_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
#
	#move_and_slide()
