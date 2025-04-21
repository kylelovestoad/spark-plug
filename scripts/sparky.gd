extends CharacterBody2D

@export
var move_speed = 150.0

@export
var jump_buffer_max = 0.2 # The max time before input is no longer buffered
var jump_buffer_time = 0.0 
var jump_buffered = false

var jump_time = 0.0 
var holding_jump = false

var alive = true

@export
var min_jump_height : float = 10
@export 
var max_jump_height: float = 20
@export 
var jump_ascend_time : float
@export 
var jump_descend_time : float

# Uses kinematics to solve for velocity and acceleration for different. All negative due to direction
@onready 
var jump_velocity : float = -((2.0 * min_jump_height) / jump_ascend_time) # v_o = 2y / t 
@onready 
var jump_gravity : float = -((-2.0 * min_jump_height) / pow(jump_ascend_time, 2)) # a = 2y / t^2
@onready 
var fall_gravity : float = -((-2.0 * min_jump_height) / pow(jump_descend_time, 2)) # a = 2y / t^2
@onready 
var hold_jump_accel : float = -((2.0 * (max_jump_height - min_jump_height)) / pow(max_jump_hold_time, 2)) # a = 2(y_f - y_i) / t^2


@export
var max_coyote_time = 0.1
var coyote_time = 0.0
var coyote_jump = false

@export
var max_jumps = 2
var jumps = max_jumps

@export
var max_grapples = 1
var grapples = max_grapples
var grapple_dir = Vector2.ZERO
var grapple_position = Vector2.ZERO

@export
var grapple_range: float = 10000

@export
var max_grapple_time: float = 0.1

@export 
var move_acceleration = 1000

@export 
var turn_acceleration = 1500

@export 
var air_move_acceleration = 1000

@export 
var air_turn_acceleration = 1500

@export
var max_jump_hold_time: float = 0.2

@export
var swim_turn_rate: float = 10
var swim_dir = Vector2.RIGHT


@onready
var state_machine = $StateMachine

@onready
var move_component = $MoveComponent

@onready
var camera = $Camera2D

func _ready() -> void:
	state_machine.init(self)
	
func _draw() -> void:
	state_machine.draw()	
	
func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	queue_redraw()
	state_machine.process_frame(delta)
	
func gravity() -> Vector2:
	return Vector2(
		0,
		jump_gravity if velocity.y < 0.0 else fall_gravity
	)
	
func try_grapple():
	
	if not move_component.try_grapple() or grapples <= 0:
		return {}
	
	var move_dir = move_component.try_movement()
	if move_dir == Vector2.ZERO:
		grapple_dir = Vector2.RIGHT # Default grapple dir is right
	else:
		grapple_dir = move_dir
	
	var space_state = get_world_2d().direct_space_state
	# Raycast to find something to latch onto
	var endpoint = grapple_dir * grapple_range
	var query = PhysicsRayQueryParameters2D.create(
		global_position, 
		global_position + endpoint
	)
	
	# Excludes the object grappling
	query.exclude = [self]
	
	var result = space_state.intersect_ray(query)
	
	return result


func _on_room_hit_box_area_entered(area: Area2D) -> void:
	print("TestME")
	var collision: CollisionShape2D = area.get_node("CollisionShape2D")
	# This should never be false if it managed to enter the area	
	assert(collision)

	
	var room_size = collision.shape.extents * 2
	print(room_size)
	camera.limit_top = collision.global_position.y - room_size.y / 2
	camera.limit_left = collision.global_position.x - room_size.x / 2
	camera.limit_bottom = camera.limit_top + room_size.y
	camera.limit_right = camera.limit_left + room_size.x
