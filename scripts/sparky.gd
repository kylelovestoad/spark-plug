extends CharacterBody2D

@onready
var state_machine = $StateMachine

@onready
var move_component = $MoveComponent

@export
var move_speed = 200.0

@export
var jump_buffer_max = 0.2 # The max time before input is no longer buffered
var jump_buffer_time = 0.0 
var jump_buffered = false

var jump_time = 0.0 
var holding_jump = false

@export
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
