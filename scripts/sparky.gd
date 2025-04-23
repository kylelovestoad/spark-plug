class_name Player
extends CharacterBody2D

@export
var move_speed = 150.0

@export
var jump_buffer_max = 0.15 # The max time before input is no longer buffered
var jump_buffer_time = 0.0 
var jump_buffered = false

var jump_time = 0.0 
var holding_jump = false

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
var grapple_speed: float = 500

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

@export
var grapple_state: State

@export
var grapple_particles: CPUParticles2D

@export
var state_machine: Node

@export
var move_component: Node

@export
var health_component: Node

@export
var camera: Camera2D

@export
var animations: AnimatedSprite2D

@export
var max_lives: int = 3
var lives = max_lives

@export
var game_over_scene: PackedScene

@onready
var current_spawn = global_position

@onready
var smoothing = false

func _ready() -> void:
	state_machine.init(self)
	
func _draw() -> void:
	state_machine.draw()	
		
func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	grapple_particles.emitting = grapples != 0
		

func _process(delta: float) -> void:
	# FIXME, Look out for this in the future, this could cause performance bugs?
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
	

func update_camera_limits(collision: CollisionShape2D, room_size: Vector2) -> void:
	var target_top = collision.global_position.y - room_size.y / 2
	var target_left = collision.global_position.x - room_size.x / 2

	camera.limit_top = target_top
	camera.limit_left = target_left
	camera.limit_bottom = target_top + room_size.y
	camera.limit_right = target_left + room_size.x
	
func align_sprite(direction: int):
	if direction == 1:
		animations.flip_h = false
	elif direction == -1:
		animations.flip_h = true
	

func _on_room_hit_box_area_entered(area: Area2D) -> void:
	var collision: CollisionShape2D = area.get_node("CollisionShape2D")
	# This should never be false if it managed to enter the area	
	assert(collision)

	# Multiplying by camera zoom gets the correct viewport size 
	var view_size: Vector2 = get_viewport_rect().size * camera.zoom
	var room_size: Vector2 = collision.shape.extents * 2
	var room_center: Vector2 = collision.global_position
	
	if room_size.y < view_size.y:
		room_size.y = view_size.y
		
	if room_size.x < view_size.x:
		room_size.x = view_size.x
			
	update_camera_limits(collision, room_size)
	
	# The first time the player enters into the scene, smoothing won't be there because it looks better
	# This turns them on afterwards
	# HACK fix this because it's bad design, but it works
	if not smoothing:
		smoothing = true
		camera.limit_smoothed = smoothing
		camera.position_smoothing_enabled = smoothing

func _on_died() -> void:
	health_component.alive = false
	visible = false
	lives -= 1
	Game.deaths += 1
	if lives == 0:
		game_over()
	else:
		respawn()
	
func respawn() -> void:
	global_position = current_spawn
	state_machine.reset()
	jumps = max_jumps
	grapples = max_grapples
	velocity = Vector2.ZERO
	visible = true
	health_component.respawn()
	
func try_collide_metal() -> TileMapLayer:
	var collision = get_last_slide_collision()
	if collision and collision.get_collider() is TileMapLayer:
		var layer = collision.get_collider() as TileMapLayer
		if layer:
			var tile_pos = layer.local_to_map(collision.get_position())
			var tile_data = layer.get_cell_tile_data(tile_pos)
			if tile_data and tile_data.get_custom_data("Metal"):
				return layer
	return null

func game_over() -> void:
	get_tree().change_scene_to_packed(game_over_scene)
	
func _on_checkpoint_reached(new_positon: Vector2) -> void:
	current_spawn = new_positon
