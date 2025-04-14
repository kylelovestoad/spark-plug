extends CharacterBody2D

@onready
var state_machine = $StateMachine

@onready
var move_component = $MoveComponent

@export
var move_speed = 150.0

@export
var jump_buffer_max = 0.2 # The max time before input is no longer buffered
var jump_buffer_time = 0.0 
var jump_buffered = false

var jump_time = 0.0 
var holding_jump = false

@export
var jump_height : float
@export 
var jump_time_to_peak : float
@export 
var jump_time_to_descent : float
@onready 
var jump_velocity : float =  -((2.0 * jump_height) / jump_time_to_peak)
@onready 
var jump_gravity : float = -((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak))
@onready 
var fall_gravity : float = -((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent))

@export
var max_coyote_time = 0.1 # TODO finish coyote time
var coyote_time = 0.0
var coyote_jump = false

@export
var max_jumps = 2
var jumps = max_jumps

@export 
var move_acceleration = 1000

@export 
var turn_acceleration = 1500

@export 
var air_move_acceleration = 1000

@export 
var air_turn_acceleration = 1500

@export
var hold_jump_accel: float = -1000.0
@export
var max_jump_hold_time: float = 0.2

func _ready() -> void:
	state_machine.init(self)
	
func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	print(velocity)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
	

func test_me() -> Vector2:
	return Vector2(
		0,
		jump_gravity if velocity.y < 0.0 else fall_gravity
	)
