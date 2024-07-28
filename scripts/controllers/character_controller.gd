class_name CharacterController
extends CharacterBody2D

## Default variables
@export var character: PlatformerResource

# Character velocity influenced by acceleration and friction
var character_velocity: Vector2 = Vector2.ZERO
# Final speed to be applied to the character
@onready var real_speed: float = character.speed
# Final acceleration influenced by normal acceleration and air acceleration
@onready var real_acceleration: float = character.acceleration
# Final friction influenced by normal friction and air friction
@onready var real_friction: float = character.friction

## Variables
var physics_fps: float = 0.0
var ignore_input: float = 0.0
var dash_remaining: int = 0
var dash_is_active: bool = false
var char_velocity: Vector2 = Vector2.ZERO
var move_cooldown: Vector2 = Vector2(0.0, 0.0)

var motion: Vector2 = Vector2.ZERO
var _old_position: Vector2 = Vector2.ZERO

## Signals
signal max_speed_reached
signal movement_stopped
signal movement_occurred
signal dash_started
signal dash_ended


func _ready() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING


func _physics_process(delta: float) -> void:
	physics_fps = 1.0 / delta

	var target_speed = character_velocity * character.speed * physics_fps
	if ignore_input > 0:
		target_speed = Vector2.ZERO

	# Horizontal movement
	if move_cooldown.x <= 0:
		if target_speed.x != 0:
			if char_velocity.x != 0 and sign(char_velocity.x) != sign(target_speed.x):
				char_velocity.x = move_toward(char_velocity.x, 0, character.turn_speed * physics_fps)
			else:
				char_velocity.x = move_toward(char_velocity.x, target_speed.x, real_acceleration * physics_fps)
		else:
			char_velocity.x = move_toward(char_velocity.x, 0, real_friction * physics_fps)

	# Vertical movement
	if move_cooldown.y <= 0:
		if target_speed.y != 0:
			if char_velocity.y != 0 and sign(char_velocity.y) != sign(target_speed.y):
				char_velocity.y = move_toward(char_velocity.y, 0, character.turn_speed * physics_fps)
			else:
				char_velocity.y = move_toward(char_velocity.y, target_speed.y, real_acceleration * physics_fps)
		else:
			char_velocity.y = move_toward(char_velocity.y, 0, real_friction * physics_fps)


	velocity = char_velocity
	move_and_slide()
	char_velocity = velocity

	if is_on_floor():
		dash_remaining = character.dash_count

	ignore_input = move_toward(ignore_input, 0, delta)
	move_cooldown.x = move_toward(move_cooldown.x, 0, delta)
	move_cooldown.y = move_toward(move_cooldown.y, 0, delta)

	motion = global_position - _old_position
	_old_position = global_position


func dash(direction: float):
	dash_remaining -= 1

	var multiplier: Vector2 = Vector2.ONE
	var _direction_angle = round(rad_to_deg(direction))

	if _direction_angle == 0:
		multiplier.x = character.dash_right_scale
	elif _direction_angle == 180:
		multiplier.x = character.dash_left_scale
	elif _direction_angle >= -135 and _direction_angle <= -45:
		multiplier.y = character.dash_up_scale
	elif _direction_angle == 90:
		multiplier.y = character.dash_down_scale

	var dash_speed = Vector2.RIGHT.rotated(direction)
	char_velocity = dash_speed * character.dash_strength * multiplier * physics_fps
	ignore_input = character.dash_cooldown
	move_cooldown = Vector2(0.5, 1.0) * character.dash_cooldown

	dash_is_active = true
	dash_started.emit()

	await get_tree().create_timer(character.dash_strength * character.dash_cooldown).timeout

	dash_is_active = false
	dash_ended.emit()


func can_dash() -> bool:
	return dash_remaining > 0
