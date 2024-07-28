class_name CharacterPlatformer
extends CharacterController

## Signals
signal landed(velocity_y)
signal jumped(is_coyote_jump, is_buffered, is_wall_jump)
signal turned(direction)
signal airborne
signal falling

## Variables
var is_falling: bool = false
var on_floor: bool = false
var on_ceiling: bool = false
var on_wall: bool = false
var jump_is_pressed: int = 0
var is_jumping: bool = false
var fall_velocity: float = 0.0
var wall_direction: int = 0
var right_wall: bool = false
var left_wall: bool = false
var is_wall_sliding: bool = false
var on_edge: bool = false

var _remaining_jump_buffer: float = 0.0
var _remaining_coyote_time: float = 0.0
var _gravity_multiplier: float = 1.0
var _gravity_scale: float = 1.0
var _control: float = 1.0
var _max_gravity: float = 1.0
var _last_jump_type: int = 0
var _last_turned_direction: int = 1
var _buffered_jump_strength: float = 0.0


func _ready() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_GROUNDED
	landed.connect(_on_landed)


func _physics_process(delta: float) -> void:
	physics_fps = 1.0 / delta
	
	if not on_floor and is_on_floor():
		_on_landed(fall_velocity)
		landed.emit(fall_velocity)
	
	if on_floor and not is_on_floor():
		airborne.emit()
	
	on_floor = is_on_floor()
	on_ceiling = is_on_ceiling()
	
	var right_horizontal_movement = Vector2(character.wall_safe_margin, 0)
	var left_horizontal_movement = Vector2(-character.wall_safe_margin, 0)
	right_wall = test_move(transform, right_horizontal_movement)
	left_wall = test_move(transform, left_horizontal_movement)
	on_wall = right_wall or left_wall
	
	var translated_global_position = global_transform.translated(Vector2(character.edge_check_distance * _last_turned_direction, 1))
	var downward_direction = Vector2(0, 1)
	on_edge = not test_move(translated_global_position, downward_direction)
	
	var horizontal_direction = sign(character_velocity.x)
	if (
		horizontal_direction != 0 and _last_turned_direction != horizontal_direction
		and horizontal_direction != sign(velocity.x)
	):
		_last_turned_direction = horizontal_direction
		turned.emit(_last_turned_direction)
	
	# Calculate the wall direction
	if on_wall:
		wall_direction = 1 if right_wall else -1
	
	var active_wall_value = (
		(velocity.y > 0 and on_wall and (wall_direction == horizontal_direction)
		or not character.wall_when_moving) and character.wall_active
	)
	is_wall_sliding = active_wall_value
	_gravity_scale = character.wall_slide_gravity if active_wall_value else character.gravity
	
	var target_speed = character_velocity * character.speed * physics_fps
	if ignore_input > 0:
		target_speed = Vector2.ZERO
	
	_max_gravity = character.wall_slide_max_gravity if active_wall_value else character.max_gravity
	
	# Horizontal movement
	if move_cooldown.x <= 0:
		if target_speed.x != 0:
			if char_velocity.x != 0 and sign(char_velocity.x) != sign(target_speed.x):
				char_velocity.x = move_toward(char_velocity.x, 0, character.turn_speed * physics_fps * _control)
			else:
				char_velocity.x = move_toward(char_velocity.x, target_speed.x, real_acceleration * physics_fps * _control)
		else:
			char_velocity.x = move_toward(char_velocity.x, 0, real_friction * physics_fps * _control)
	
	# Apply gravity
	if not on_floor and move_cooldown.y <= 0:
		char_velocity.y = move_toward(char_velocity.y, _max_gravity * physics_fps, _gravity_scale * _gravity_multiplier * physics_fps)
	
	_remaining_coyote_time = move_toward(_remaining_coyote_time, 0, delta)
	_remaining_jump_buffer = move_toward(_remaining_jump_buffer, 0, delta)
	ignore_input = move_toward(ignore_input, 0, delta)
	move_cooldown.x = move_toward(move_cooldown.x, 0, delta)
	move_cooldown.y = move_toward(move_cooldown.y, 0, delta)
	
	_handle_jump()
	_calculate_gravity()
	velocity = char_velocity
	calculate_corner_correction()
	move_and_slide()
	char_velocity = velocity
	
	if is_on_floor():
		dash_remaining = character.dash_count
	
	motion = global_position - _old_position
	_old_position = global_position


var _previously_jumped = false

func jump() -> void:
	jump_is_pressed = 1
	_previously_jumped = true


func release_jump() -> void:
	if _previously_jumped:
		jump_is_pressed = -1
		_previously_jumped = false


func _handle_jump() -> void:
	# Release jump
	if jump_is_pressed < 0:
		jump_is_pressed = 0
		
		_buffered_jump_strength /= character.jump_cutoff
		if not on_floor and not dash_is_active:
			char_velocity.y /= character.jump_cutoff
	
	# Press jump
	if jump_is_pressed > 0 or _remaining_jump_buffer > 0:
		if on_floor or _remaining_coyote_time > 0:
			var jump_is_buffered: bool = _remaining_jump_buffer > 0
			_last_jump_type = 1
			_remaining_coyote_time = 0
			
			var jumping_height = (character.jump_height if not jump_is_buffered else _buffered_jump_strength) * character.gravity_scale * physics_fps
			char_velocity.y = -jumping_height
			is_jumping = true
			
			if jump_is_pressed:
				_remaining_jump_buffer = 0
		else:
			if on_wall and velocity.y > 0:
				_last_jump_type = 2
				
				var jumping_offset = character.wall_jump_min_offset if character_velocity.x == 0 else character.wall_jump_offset
				var jumping_height = character.wall_jump_min_height if character_velocity.x == 0 else character.wall_jump_height
				
				char_velocity.y = -jumping_height * character.gravity_scale * physics_fps
				char_velocity.x = -wall_direction * jumping_offset * physics_fps
				
				if character_velocity.x != 0:
					ignore_input = character.wall_jump_cooldown
				
				if jump_is_pressed:
					_remaining_jump_buffer = character.wall_jump_buffer
					_buffered_jump_strength = character.wall_jump_height
			else:
				if jump_is_pressed:
					_remaining_jump_buffer = character.jump_buffer if _last_jump_type == 2 else character.jump_buffer
					_buffered_jump_strength = character.jump_height if _last_jump_type == 2 else character.jump_height
				_last_jump_type = 0
		
		if _last_jump_type != 0:
			jumped.emit(not on_floor and _remaining_coyote_time > 0, _remaining_jump_buffer > 0, _last_jump_type == 2)
		jump_is_pressed = 0


func _calculate_gravity() -> void:
	# Going upwards
	if char_velocity.y < 0:
		is_falling = false
		
		if on_floor:
			_control = 1.0
			real_acceleration = character.acceleration
			real_friction = character.friction
			_gravity_multiplier = character.gravity_scale
		else:
			_control = character.air_control
			real_acceleration = character.air_acceleration
			real_friction = character.air_friction
			
			if jump_is_pressed and is_jumping:
				pass
			
			_gravity_multiplier = character.jump_gravity
		
		fall_velocity = 0.0
	
	# Going downwards
	elif char_velocity.y > 0:
		if on_floor:
			_control = 1.0
			real_acceleration = character.acceleration
			real_friction = character.friction
			_gravity_multiplier = character.gravity_scale
		else:
			if not is_falling:
				falling.emit()
			
			is_falling = true
			_control = character.air_control
			real_acceleration = character.air_acceleration
			real_friction = character.air_friction
			_gravity_multiplier = character.fall_gravity
		
		fall_velocity = max(fall_velocity, char_velocity.y)
	else:
		if on_floor:
			is_falling = false
			
			_control = 1.0
			real_acceleration = character.acceleration
			real_friction = character.friction
			
			_remaining_coyote_time = character.coyote_time
			is_jumping = false
			jump_is_pressed = 0
		
		_gravity_multiplier = character.gravity_scale


func _on_landed(_velocity_y) -> void:
	on_floor = true
	jump_is_pressed = 0


func calculate_corner_correction() -> void:
	var delta = get_physics_process_delta_time()
	
	# Vertical correction
	if velocity.y < 0 and test_move(global_transform, Vector2(0, velocity.y * delta)):
		for i in range(1, character.corner_correction_steps + 1):
			for j in [-1.0, 1.0]:
				var vertical_translated_position = global_transform.translated(Vector2(i*j, 0))
				var vertical_motion = Vector2(0, velocity.y * delta)
				
				if not test_move(vertical_translated_position, vertical_motion):
					translate(Vector2(i*j, 0))
					return
	
	# Horizontal correction
	if (
	  abs(velocity.y) < character.gravity and velocity.x != 0
	  and test_move(global_transform, Vector2(velocity.x * delta, 0))
	):
		for i in range(1, character.corner_correction_steps + 2):
			for j in [-1.0, 1.0]:
				var horizontal_translated_position = global_transform.translated(Vector2(0, i*j))
				var horizontal_motion = Vector2(velocity.x * delta, 0)
				
				if not test_move(horizontal_translated_position, horizontal_motion):
					translate(Vector2(0, i*j))
					return
